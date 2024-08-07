import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/Const/trip_var.dart';
import 'package:new_app/Drivers/driver_deatails.dart';
import 'package:new_app/Models/direction_deteils.dart';
import 'package:new_app/Models/info_dialoge.dart';
import 'package:new_app/Models/online_earby_drivers.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/comen/manage_drivers_methods.dart';
import 'package:new_app/comen/push_notification.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> with WidgetsBindingObserver {
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  double bottomMapPadding = 0;
  DirectionDetails? tripDirectionDetailsInfo;
  List<LatLng> polylineCoOrdinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  bool isDrawerOpened = true;
  String stateOfApp = "normal";
  bool nearbyOnlineDriversKeysLoaded = false;
  BitmapDescriptor? carIconNearbyDriver;
  BitmapDescriptor? threeWheelIcon;
  BitmapDescriptor? fourWheelIcon;
  BitmapDescriptor? sevenWheelIcon;
  DatabaseReference? tripRequestRef;
   StreamSubscription<DatabaseEvent>? tripStreamSubscription;
    bool requestingDirectionDetailsInfo = false;

     double requestContainerHeight = 0;
      double tripContainerHeight = 0;

  double animationValue = 0; // Initial animation value
  String? selectedDriverId;
  String trippid = "";

  void loadVehicleIcons() {
    if (threeWheelIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context, size: const Size(48, 48));
      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/three_wheel.png').then((icon) {
        setState(() {
          threeWheelIcon = icon;
        });
      });
    }

    if (fourWheelIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context, size: const Size(48, 48));
      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/four_wheel.png').then((icon) {
        setState(() {
          fourWheelIcon = icon;
        });
      });
    }

    if (sevenWheelIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context, size: const Size(48, 48));
      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/seven_wheel.png').then((icon) {
        setState(() {
          sevenWheelIcon = icon;
        });
      });
    }
  }

  makeDriverNearbyCarIcon() {
    if (carIconNearbyDriver == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context, size: const Size(0.5, 0.5)); // Smaller size
      BitmapDescriptor.fromAssetImage(
        configuration,
        "assets/images/transport.png",
      ).then((iconImage) {
        carIconNearbyDriver = iconImage;
      });
    }
  }

  String userName = "";

  void getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;
    LatLng positionOfUserInLatLng = LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng, zoom: 14);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await CommonMethods.convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(currentPositionOfUser!, context);
    initializeGeoFireListener();
  }

  void updateAvailableNearbyOnlineDriversOnMap() {
    setState(() {
      markerSet.clear();
    });

    Set<Marker> markersTempSet = <Marker>{};

    for (OnlineNearbyDrivers eachOnlineNearbyDriver in ManageDriversMethods.nearbyOnlineDriversList) {
      LatLng driverCurrentPosition = LatLng(eachOnlineNearbyDriver.latDriver!, eachOnlineNearbyDriver.lngDriver!);

      BitmapDescriptor vehicleIcon;

      switch (eachOnlineNearbyDriver.vehicleType) {
        case '3-wheel':
          vehicleIcon = threeWheelIcon!;
          break;
        case '4-wheel':
          vehicleIcon = fourWheelIcon!;
          break;
        case '7-wheel':
          vehicleIcon = sevenWheelIcon!;
          break;
        default:
          vehicleIcon = carIconNearbyDriver!;
      }

      String? driverId = eachOnlineNearbyDriver.uidDriver;
      Marker driverMarker = Marker(
        markerId: MarkerId("driver ID = $driverId"),
        position: driverCurrentPosition,
        icon: vehicleIcon,
        onTap: () async {
          print("Driver ID: $driverId");
          DataSnapshot driverSnapshot = await FirebaseDatabase.instance.ref().child("drivers").child(driverId!).get();
          if (driverSnapshot.exists) {
            Map<dynamic, dynamic>? driverData = driverSnapshot.value as Map<dynamic, dynamic>?;
            
              // Save the selected driverId
             
            if (driverData != null) {

               setState(() {
                selectedDriverId = driverId;
              });
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 20,
                        child: Container(
                          height: 300,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            color: Color.fromARGB(255, 236, 232, 232),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 130,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(32)),
                                    ),
                                    child: Image.network(
                                      driverData['photo'] ?? 'https://via.placeholder.com/150',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Driver Name: ${driverData['name']}', style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      Text('Car Number: ${driverData['car_details']['carNumber']}', style: const TextStyle(color: Colors.black, fontSize: 14)),
                                      const SizedBox(height: 8),
                                      Text('Car Seats: ${driverData['car_details']['carSeats']}', style: const TextStyle(color: Colors.black, fontSize: 14)),
                                      const SizedBox(height: 8),
                                       Text('Car Model: ${driverData['car_details']['careModel']}', style: const TextStyle(color: Colors.black, fontSize: 14)),
                                      const SizedBox(height: 8),
                                      Text('Phone: ${driverData['phone']}', style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: MaterialButtons(
                                  text: 'Enjoy Your Ride!'.tr(),
                                  textcolor: Colors.white,
                                  meterialColor: const Color.fromARGB(255, 3, 22, 60),
                                  onTap: () async {

                                    
                                   if (selectedDriverId != null) {

                                   
                                     MakeTriprequst();
                                     
                                    
                                       String driverId = selectedDriverId!;
                                       String deviceToken = driverData['deviceToken']; // Ensure this field exists in your driver data
                                       String tripID = trippid; // Replace with actual trip ID
                                      
                                         String currentDriver = driverId; 

                                       // await PushNotificationService.sendNotificationToSelectedDriver(deviceToken, context, tripID);

                                     sendNotificationToDriver(currentDriver,tripID);    
                                    

                                   

                                    } else {
                                      print('Error: selectedDriverId is null');
                                    }


                                  },
                                  elevationsize: 20,
                                  containerheight: 40,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            print("Driver not found!");
          }
        },
      );

      markersTempSet.add(driverMarker);
    }

    setState(() {
      markerSet = markersTempSet;
    });
  }

  void initializeGeoFireListener() {
    Geofire.initialize("onlineDrivers");
    Geofire.queryAtLocation(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude, 22)! // location radius change here
        .listen((driverEvent) {
      if (driverEvent != null) {
        var onlineDriverChild = driverEvent["callBack"];

        switch (onlineDriverChild) {
          case Geofire.onKeyEntered:
            OnlineNearbyDrivers onlineNearbyDrivers = OnlineNearbyDrivers();
            onlineNearbyDrivers.uidDriver = driverEvent["key"];
            onlineNearbyDrivers.latDriver = driverEvent["latitude"];
            onlineNearbyDrivers.lngDriver = driverEvent["longitude"];
            ManageDriversMethods.nearbyOnlineDriversList.add(onlineNearbyDrivers);

            if (nearbyOnlineDriversKeysLoaded == true) {
              // update drivers on google map
              updateAvailableNearbyOnlineDriversOnMap();
            }
            break;
          case Geofire.onKeyExited:
            ManageDriversMethods.removeDriverFromList(driverEvent["key"]);
            // update drivers on google map
            updateAvailableNearbyOnlineDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            OnlineNearbyDrivers onlineNearbyDrivers = OnlineNearbyDrivers();
            onlineNearbyDrivers.uidDriver = driverEvent["key"];
            onlineNearbyDrivers.latDriver = driverEvent["latitude"];
            onlineNearbyDrivers.lngDriver = driverEvent["longitude"];
            ManageDriversMethods.updateOnlineNearbyDriversLocation(onlineNearbyDrivers);
            // update drivers on google map
            updateAvailableNearbyOnlineDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            nearbyOnlineDriversKeysLoaded = true;
            // update drivers on google map
            updateAvailableNearbyOnlineDriversOnMap();
            break;
        }
      }
    });
  }


  //new lines

   cancelRideRequest() {
    //remove ride request from database
    tripRequestRef!.remove();
    setState(() {
      stateOfApp = "normal";
    });
  }


   MakeTriprequst() {
    tripRequestRef =
        FirebaseDatabase.instance.ref().child("tripRequests").push();

    var pickUpLocation =
        Provider.of<AppInfo>(context, listen: false).pickUpLocation;
                 
    var dropOffDestinationLocation =
        Provider.of<AppInfo>(context, listen: false).dropOffLocation;

    Map pickUpCoOrdinatesMap = {
      "latitude": pickUpLocation!.latitudePosition.toString(),
      "longitude": pickUpLocation.longitudePosition.toString(),
    };

    

    Map dropOffDestinationCoOrdinatesMap = {
      "latitude": dropOffDestinationLocation!.latitudePosition.toString(),
      "longitude": dropOffDestinationLocation.longitudePosition.toString(),
    };
 

    Map driverCoOrdinates = {
      "latitude": "",
      "longitude": "",
    };

    trippid = tripRequestRef!.key!;
     

    Map dataMap = {
      "tripID": tripRequestRef!.key,
      "publishDateTime": DateTime.now().toString(),
      "userName": userName,
      "userPhone": userPhone,
      "userID": userID,
      "pickUpLatLng": pickUpCoOrdinatesMap,
      "dropOffLatLng": dropOffDestinationCoOrdinatesMap,
      "pickUpAddress": pickUpLocation.placeName,
      "dropOffAddress": dropOffDestinationLocation.placeName,
      "driverID": "waiting",
      "carDetails": "",
      "driverLocation": driverCoOrdinates,
      "driverName": "",
      "driverPhone": "",
      "driverPhoto": "",
      "fareAmount": "",
      "status": "new",
    }; 

    print(',,,,,,,,,,,,,,,,,,,,,,, $dataMap');
 
    tripRequestRef!.set(dataMap);

    
    tripStreamSubscription =
        tripRequestRef!.onValue.listen((eventSnapshot) async {
      if (eventSnapshot.snapshot.value == null) {
        return;
      }
      if ((eventSnapshot.snapshot.value as Map)["driverName"] != null) {
        nameDriver = (eventSnapshot.snapshot.value as Map)["driverName"];
       
      }
      if ((eventSnapshot.snapshot.value as Map)["driverPhone"] != null) {
        phoneNumberDriver =
            (eventSnapshot.snapshot.value as Map)["driverPhone"];
            
      }
      if ((eventSnapshot.snapshot.value as Map)["driverPhoto"] != null) {
        photoDriver = (eventSnapshot.snapshot.value as Map)["driverPhoto"];
        
      }
      if ((eventSnapshot.snapshot.value as Map)["carDetails"] != null) {
        carDetailsDriver = (eventSnapshot.snapshot.value as Map)["carDetails"];
        
      }

      if ((eventSnapshot.snapshot.value as Map)["status"] != null) {
        status = (eventSnapshot.snapshot.value as Map)["status"];
        
       
      }

      if ((eventSnapshot.snapshot.value as Map)["driverLocation"] != null) {
        double driverLatitude = double.parse(
            (eventSnapshot.snapshot.value as Map)["driverLocatio"]["latitude"]
                .toString());
        double driverLongitude = double.parse(
            (eventSnapshot.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());
        LatLng driverCurrentLocationLatLng =
            LatLng(driverLatitude, driverLongitude);

        if (status == "assepted") {
          //update info for pickup to user on UI
          //info from driver current location to user pickup location
          updateFromDriverCurrentLocationToPickUp(driverCurrentLocationLatLng);
        } else if (status == "arrived") {
          setState(() {
            tripStatusDisplay = 'Driver has Arrived';
          });
        } else if (status == "ontrip") {
          //update info for dropoff to user on UI
          //info from driver current location to user dropoff location
         //  updateFromDriverCurrentLocationToDropOffDestination(driverCurrentLocationLatLng);
        }
      }
      if (status == "accepted") {

        displayTripDetailsContainer();

        Geofire.stopListener();

        //remove drivers markers
        setState(() {
          markerSet.removeWhere(
              (element) => element.markerId.value.contains("driver"));
        });
      }
      if (status == "ended") {
        if ((eventSnapshot.snapshot.value as Map)["fareAmount"] != null) {
          // var responseFromPaymentDialog = await showDialog(
          // context: context,
          // builder: (BuildContext context) =>
          // PaymentDialog(fareAmount: fareAmount.toString()),
          // );
          //   if(responseFromPaymentDialog == "paid")
          {
                                // tripRequestRef!.onDisconnect();
                                // tripRequestRef = null;

                                //  tripStreamSubscription!.cancel();
                                //  tripStreamSubscription = null;

                                //  resetAppNow();

            Restart.restartApp();
          }
        }
      }
    });
  }


   displayTripDetailsContainer() {
    setState(() {
      requestContainerHeight = 0;
      tripContainerHeight = 291;
      bottomMapPadding = 281;
    });
  }


  updateFromDriverCurrentLocationToPickUp(driverCurrentLocationLatLng) async {
    if (!requestingDirectionDetailsInfo) {
      requestingDirectionDetailsInfo = true;

      var userPickUpLocationLatLng = LatLng(
          currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

      var directionDetailsPickup =
          await CommonMethods.getDirectionDetailsFromAPI(
              driverCurrentLocationLatLng, userPickUpLocationLatLng);

      if (directionDetailsPickup == null) {
        return;
      }

      setState(() {
        tripStatusDisplay =
            "Driver is Coming - ${directionDetailsPickup.durationTextString}";
      });

      requestingDirectionDetailsInfo = false;
    }
  }


  //TRANSFER DATA HERE TO PUSH_NOTIFICATION PAGE FOR NOTIFICATION

  



  updateFromDriverCurrentLocationToDropOffDestination(
      driverCurrentLocationLatLng) async {
    if (!requestingDirectionDetailsInfo) {
      requestingDirectionDetailsInfo = true;

      var dropOffLocation =
          Provider.of<AppInfo>(context, listen: false).dropOffLocation;
      var userDropOffLocationLatLng = LatLng(dropOffLocation!.latitudePosition!,
          dropOffLocation.longitudePosition!);

      var directionDetailsPickup =
          await CommonMethods.getDirectionDetailsFromAPI(
              driverCurrentLocationLatLng, userDropOffLocationLatLng);

      if (directionDetailsPickup == null) {
        return;
      }

      setState(() {
        tripStatusDisplay =
            "Driving to DropOff Location - ${directionDetailsPickup.durationTextString}";
      });

      requestingDirectionDetailsInfo = false;
    }
  }



                                             sendNotificationToDriver(String driverId, String tripID) {
                                               //update driver's newTripStatus - assign tripID to current driver
                                                DatabaseReference currentDriverRef = FirebaseDatabase.instance
                                                          .ref()
                                                          .child("drivers")
                                                          .child(driverId)
                                                          .child("newTripStatus");

                                                           

                                                       
                                                  currentDriverRef.set(tripRequestRef!.key);

                                                  //get current driver device recognition token
                                                  DatabaseReference tokenOfCurrentDriverRef = FirebaseDatabase.instance
                                                      .ref()
                                                      .child("drivers")
                                                      .child(driverId)
                                                      .child("deviceToken");

                                                     

                                                  tokenOfCurrentDriverRef.once().then((dataSnapshot) {
                                                    if (dataSnapshot.snapshot.value != null) {
                                                      String deviceToken = dataSnapshot.snapshot.value.toString();
                                                       print('..................... $deviceToken');
                                                      //send notification
                                                      PushNotificationService.sendNotificationToSelectedDriver(        
                                                          deviceToken, context, tripRequestRef!.key.toString());
                                                    } else {
                                                      return;
                                                    }

                                                    const oneTickPerSec = Duration(seconds: 1);
                                                    var timerCountDown = Timer.periodic(oneTickPerSec, (timer) {
                                                      requestTimeoutDriver = requestTimeoutDriver - 1;

                                                      //when trip request is not requesting means trip request cancelled - stop timer
                                                      /*   if(stateOfApp != "requesting")
                                                      {
                                                        timer.cancel();
                                                        currentDriverRef.set("cancelled");
                                                        currentDriverRef.onDisconnect();
                                                        requestTimeoutDriver = 20;
                                                      }*/

                                                      //when trip request is accepted by online nearest available driver
                                                      currentDriverRef.onValue.listen((dataSnapshot) {
                                                        if (dataSnapshot.snapshot.value.toString() == "accepted") {
                                                          timer.cancel();
                                                          currentDriverRef.onDisconnect();
                                                          requestTimeoutDriver = 20;
                                                        }
                                                      });
                                                      //if 20 seconds passed - send notification to next nearest online available driver
                                                      if (requestTimeoutDriver == 0) {
                                                        currentDriverRef.set("timeout");
                                                        timer.cancel();
                                                        currentDriverRef.onDisconnect();
                                                        requestTimeoutDriver = 20;

                                                        //send notification to next nearest online available driver
                                                       // searchDriver();
                                                      }
                                                    });
                                                  });
                                             }

 


  @override
  Widget build(BuildContext context) {
    makeDriverNearbyCarIcon();
    loadVehicleIcons();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(32),
              ),
              height: 600,
              child: Center(
                child: Container(
                  height: 400,
                  child: GoogleMap(
                    padding: EdgeInsets.only(top: 26, bottom: bottomMapPadding),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    polylines: polylineSet,
                    markers: markerSet,
                    circles: circleSet,
                    initialCameraPosition: googlePlexInitialPosition,
                    onMapCreated: (GoogleMapController mapController) {
                      controllerGoogleMap = mapController;

                      googleMapCompleterController.complete(controllerGoogleMap);

                      setState(() {
                        bottomMapPadding = 300;
                        getCurrentLiveLocationOfUser();
                      });

                      getCurrentLiveLocationOfUser();
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 400,
          )
        ],
      ),
    );
  }
}
