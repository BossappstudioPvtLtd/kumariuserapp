import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/Const/trip_var.dart';
import 'package:new_app/Models/direction_deteils.dart';
import 'package:new_app/Models/info_dialoge.dart';
import 'package:new_app/Models/online_earby_drivers.dart';
import 'package:new_app/Show/advertisement_show.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/comen/manage_drivers_methods.dart';
import 'package:new_app/comen/push_notification.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/components/payment_dialod.dart';
import 'package:new_app/components/splashripple.dart';
import 'package:new_app/navigatinbar/botton_navigtion.dart';
import 'package:new_app/navigatinbar/trips_history_page.dart';

import 'package:new_app/search_destination.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> with WidgetsBindingObserver {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  double searchContainerHeight = 276;
  double bottomMapPadding = 0;
  double rideDetailsContainerHeight = 0;
  double requestContainerHeight = 0;
  double tripContainerHeight = 0;
  DirectionDetails? tripDirectionDetailsInfo;
  List<LatLng> polylineCoOrdinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  bool isDrawerOpened = true;
  String stateOfApp = "normal";
  bool nearbyOnlineDriversKeysLoaded = false;
  BitmapDescriptor? carIconNearbyDriver;
  DatabaseReference? tripRequestRef;
  List<OnlineNearbyDrivers>? availableNearbyOnlineDriversList;
  StreamSubscription<DatabaseEvent>? tripStreamSubscription;
  bool requestingDirectionDetailsInfo = false;

  bool isTripDetailsContainerDisplayed = false;

  double animationValue = 0; // Initial animation value

  makeDriverNearbyCarIcon() {
    if (carIconNearbyDriver == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context,
          size: const Size(0.5, 0.5)); // Smaller size
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
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;
    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    await CommonMethods.convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
        currentPositionOfUser!, context);

    await getUserInfoAndCheckBlockStatus();

    await initializeGeoFireListener();
     showDialog(
  barrierDismissible: false,
  context: context,
  builder: (BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical:100,horizontal: 10),
    child: Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius:BorderRadius.circular(16)),
    
      child: Stack(
        children: <Widget>[
          // Your existing AdvertisementShow widget
        
             const AdvertisementShow(),
        
          // Close button
          Positioned(
           top: 20,
            right: 10,
            child: IconButton(
              
              icon: const CircleAvatar(
                backgroundColor: Colors.black,
                child: 
              Icon(Icons.close,color: Colors.white,)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    ),
  ),
);

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserInfoAndCheckBlockStatus();
   
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getUserInfoAndCheckBlockStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
  tripStatusDisplayController.close();
    super.dispose();
  }

  Future<void> getUserInfoAndCheckBlockStatus() async {
    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snap = await usersRef.once();

    if (snap.snapshot.value != null) {
      final userData = snap.snapshot.value as Map;
      if (userData["blockStatus"] == "no") {
        setState(() {
          userName = (snap.snapshot.value as Map)["name"];
          userPhone = (snap.snapshot.value as Map)["phone"];
        });
      } else {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("You are blocked. Contact admin: Kumariacabs@gmail.com")));
      }
    } else {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const LoginScreen()));
    }
  }

  displayUserRideDetailsContainer() async {
    ///Directions API
    await retrieveDirectionDetails();

    setState(() {
      searchContainerHeight = 0;
      bottomMapPadding = 240;
      rideDetailsContainerHeight = 350;
      isDrawerOpened = false;
    });
  }

  retrieveDirectionDetails() async {
    var pickUpLocation =
        Provider.of<AppInfo>(context, listen: false).pickUpLocation;
    var dropOffDestinationLocation =
        Provider.of<AppInfo>(context, listen: false).dropOffLocation;

    var pickupGeoGraphicCoOrdinates = LatLng(
        pickUpLocation!.latitudePosition!, pickUpLocation.longitudePosition!);
    var dropOffDestinationGeoGraphicCoOrdinates = LatLng(
        dropOffDestinationLocation!.latitudePosition!,
        dropOffDestinationLocation.longitudePosition!);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Getting direction...".tr()),
    );
 
    ///Directions API
    var detailsFromDirectionAPI =
        await CommonMethods.getDirectionDetailsFromAPI(
            pickupGeoGraphicCoOrdinates,
            dropOffDestinationGeoGraphicCoOrdinates);

    setState(() {
      tripDirectionDetailsInfo = detailsFromDirectionAPI;
    });

    Navigator.pop(context);

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: rideDetailsContainerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(.7, .7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                       SizedBox(
                        height: 300,
                        child: Card(
                            elevation: 10,
                            
                              color: Colors.black87,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .90,
                            decoration: const BoxDecoration(
                              
                              color: Colors.black87,
                           borderRadius:BorderRadius.all(Radius.circular(16))
                            ),
                              
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (tripDirectionDetailsInfo != null)
                                                ? tripDirectionDetailsInfo!
                                                    .distanceTextString!
                                                : "",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            (tripDirectionDetailsInfo != null)
                                                ? tripDirectionDetailsInfo!
                                                    .durationTextString!
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                "assets/logo/autorickshaw.png",
                                                height: 100,
                                                width: 80,
                                              ),
                                            ),
                                            Text(
                                              (tripDirectionDetailsInfo != null)
                                                  ? "₹ ${(cMethods.calculateFareAmountFor3Seats(tripDirectionDetailsInfo!)).toString()}"
                                                  : "",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                "assets/logo/cartaxi.png",
                                                height: 100,
                                                width: 100,
                                              ),
                                            ),
                                            Text(
                                              (tripDirectionDetailsInfo != null)
                                                  ? "₹ ${(cMethods.calculateFareAmountFor4Seats(tripDirectionDetailsInfo!)).toString()}"
                                                  : "",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                "assets/logo/car7.png",
                                                height: 100,
                                                width: 100,
                                              ),
                                            ),
                                            Text(
                                              (tripDirectionDetailsInfo != null)
                                                  ? "₹ ${(cMethods.calculateFareAmountFor7Seats(tripDirectionDetailsInfo!)).toString()}"
                                                  : "",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MaterialButtons(
                                          elevationsize: 20,
                                          fontSize: 17,
                                          containerheight: 40,
                                          containerwidth: 100,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                            text: "Cancel".tr(),
                                            onTap: () {
                                              resetAppNow();
                                              Navigator.of(context).pop(false);
                                            }),

                                        MaterialButtons(
                                          elevationsize: 20,
                                          text: "Go".tr(),
                                          fontSize: 17,
                                          containerheight: 40,
                                          containerwidth: 100,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          onTap: () async {
                                            MakeTriprequst();
                                            availableNearbyOnlineDriversList =
                                            ManageDriversMethods
                                            .nearbyOnlineDriversList;
                                            //search driver
                                            searchDriver();
                                            // Navigate to the SplashRipple page
                                            await showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoTheme(
                                                  data:
                                                      const CupertinoThemeData(
                                                    brightness: Brightness
                                                        .light, // Ensure the modal is bright
                                                  ),
                                                  child: Container(
                                                    height: 250,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: Colors.black,
                                                    ),
                                                    child: const SpalshRipple(),
                                                  ),
                                                );
                                              },
                                            );
                                            // Code here will execute when returning from SplashRipple page
                                            resetAppNow(); // Reset the app state
                                            cancelRideRequest();

                                            Navigator.of(context).pop(
                                                false); // Cancel any ride requests or similar tasks
                                          },
                                        ),

                                        // Padding(
                                        //     padding: const EdgeInsets.only(
                                        //         right: 20),

                                        //     child: ElevatedButton(
                                        //       onPressed: () async {
                                        //         MakeTriprequst();
                                        //         availableNearbyOnlineDriversList =
                                        //             ManageDriversMethods
                                        //                 .nearbyOnlineDriversList;
                                        //         //search driver
                                        //         searchDriver();
                                        //         // Navigate to the SplashRipple page
                                        //         await showCupertinoModalPopup(
                                        //           context: context,
                                        //           builder:
                                        //               (BuildContext context) {
                                        //             return CupertinoTheme(
                                        //               data:
                                        //                   const CupertinoThemeData(
                                        //                 brightness: Brightness
                                        //                     .light, // Ensure the modal is bright
                                        //               ),
                                        //               child: Container(
                                        //                 height: 300,
                                        //                 width: double.infinity,
                                        //                 decoration:
                                        //                     BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(16),
                                        //                   color: Colors.black,
                                        //                 ),
                                        //                 child:
                                        //                     const SpalshRipple(),
                                        //               ),
                                        //             );
                                        //           },
                                        //         );
                                        //         // Code here will execute when returning from SplashRipple page
                                        //         resetAppNow(); // Reset the app state
                                        //         cancelRideRequest();

                                        //         Navigator.of(context).pop(
                                        //             false); // Cancel any ride requests or similar tasks
                                        //       },
                                        //       child: const Text("GO"),
                                        //     )),
                                      ],
                                    )
                                  ],
                                ),
                              
                            )),
                      ),
                    
                  ],
                ),
              ),
            ),
          );
        });

//draw route from pickup to dropOffDestination
    PolylinePoints pointsPolyline = PolylinePoints();
    List<PointLatLng> latLngPointsFromPickUpToDestination =
        pointsPolyline.decodePolyline(tripDirectionDetailsInfo!.encodedPoints!);

    polylineCoOrdinates.clear();
    if (latLngPointsFromPickUpToDestination.isNotEmpty) {
      latLngPointsFromPickUpToDestination.forEach((PointLatLng latLngPoint) {
        polylineCoOrdinates
            .add(LatLng(latLngPoint.latitude, latLngPoint.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId("polylineID"),
        color: Colors.blue,
        points: polylineCoOrdinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    //fit the polyline into the map
    LatLngBounds boundsLatLng;
    if (pickupGeoGraphicCoOrdinates.latitude >
            dropOffDestinationGeoGraphicCoOrdinates.latitude &&
        pickupGeoGraphicCoOrdinates.longitude >
            dropOffDestinationGeoGraphicCoOrdinates.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: dropOffDestinationGeoGraphicCoOrdinates,
        northeast: pickupGeoGraphicCoOrdinates,
      );
    } else if (pickupGeoGraphicCoOrdinates.longitude >
        dropOffDestinationGeoGraphicCoOrdinates.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(pickupGeoGraphicCoOrdinates.latitude,
            dropOffDestinationGeoGraphicCoOrdinates.longitude),
        northeast: LatLng(dropOffDestinationGeoGraphicCoOrdinates.latitude,
            pickupGeoGraphicCoOrdinates.longitude),
      );
    } else if (pickupGeoGraphicCoOrdinates.latitude >
        dropOffDestinationGeoGraphicCoOrdinates.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(dropOffDestinationGeoGraphicCoOrdinates.latitude,
            pickupGeoGraphicCoOrdinates.longitude),
        northeast: LatLng(pickupGeoGraphicCoOrdinates.latitude,
            dropOffDestinationGeoGraphicCoOrdinates.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(
        southwest: pickupGeoGraphicCoOrdinates,
        northeast: dropOffDestinationGeoGraphicCoOrdinates,
      );
    }

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 72));

    //add markers to pickup and dropOffDestination points
    Marker pickUpPointMarker = Marker(
      markerId: const MarkerId("pickUpPointMarkerID"),
      position: pickupGeoGraphicCoOrdinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
          title: pickUpLocation.placeName, snippet: "Pickup Location"),
    );

    Marker dropOffDestinationPointMarker = Marker(
      markerId: const MarkerId("dropOffDestinationPointMarkerID"),
      position: dropOffDestinationGeoGraphicCoOrdinates,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: dropOffDestinationLocation.placeName,
          snippet: "Destination Location"),
    );

    setState(() {
      markerSet.add(pickUpPointMarker);
      markerSet.add(dropOffDestinationPointMarker);
    });

    //add circles to pickup and dropOffDestination points
    Circle pickUpPointCircle = Circle(
      circleId: const CircleId('pickupCircleID'),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: pickupGeoGraphicCoOrdinates,
      fillColor: Colors.white,
    );

    Circle dropOffDestinationPointCircle = Circle(
      circleId: const CircleId('dropOffDestinationCircleID'),
      strokeColor: Colors.blue,
      strokeWidth: 4,
      radius: 14,
      center: dropOffDestinationGeoGraphicCoOrdinates,
      fillColor: Colors.white,
    );

    setState(() {
      circleSet.add(pickUpPointCircle);
      circleSet.add(dropOffDestinationPointCircle);
    });
  }

  resetAppNow() {
    setState(() {
      polylineCoOrdinates.clear();
      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      rideDetailsContainerHeight = 0;
      requestContainerHeight = 0;
      tripContainerHeight = 0;
      searchContainerHeight = 276;
      bottomMapPadding = 300;
      isDrawerOpened = true;

      status = "";
      nameDriver = "";
      photoDriver = "";
      phoneNumberDriver = "";
      carDetailsDriver = "";
      tripStatusDisplay = 'Driver is Arriving';
    });
  }

  cancelRideRequest() {
    //remove ride request from database
    tripRequestRef!.remove();
    setState(() {
      stateOfApp = "normal";
    });
  }

  displayRequestContainer() {
    setState(() {
      rideDetailsContainerHeight = 0;
      requestContainerHeight = 220;
      bottomMapPadding = 200;
      isDrawerOpened = true;
    });

    //send ride request
  }

  updateAvailableNearbyOnlineDriversOnMap() {
    setState(() {
      markerSet.clear();
    });

    Set<Marker> markersTempSet = <Marker>{};

    for (OnlineNearbyDrivers eachOnlineNearbyDriver
        in ManageDriversMethods.nearbyOnlineDriversList) {
      LatLng driverCurrentPosition = LatLng(
          eachOnlineNearbyDriver.latDriver!, eachOnlineNearbyDriver.lngDriver!);

      Marker driverMarker = Marker(
          markerId: MarkerId("driver ID = ${eachOnlineNearbyDriver.uidDriver}"),
          position: driverCurrentPosition,
          icon: carIconNearbyDriver!,
          onTap: () {});

      markersTempSet.add(driverMarker);
    }

    setState(() {
      markerSet = markersTempSet;
    });
  }

  initializeGeoFireListener() {
    Geofire.initialize("onlineDrivers");
    Geofire.queryAtLocation(currentPositionOfUser!.latitude,
            currentPositionOfUser!.longitude, 22)! //location radius change here
        .listen((driverEvent) {
      if (driverEvent != null) {
        var onlineDriverChild = driverEvent["callBack"];

        switch (onlineDriverChild) {
          case Geofire.onKeyEntered:
            OnlineNearbyDrivers onlineNearbyDrivers = OnlineNearbyDrivers();
            onlineNearbyDrivers.uidDriver = driverEvent["key"];
            onlineNearbyDrivers.latDriver = driverEvent["latitude"];
            onlineNearbyDrivers.lngDriver = driverEvent["longitude"];
            ManageDriversMethods.nearbyOnlineDriversList
                .add(onlineNearbyDrivers);

            if (nearbyOnlineDriversKeysLoaded == true) {
              //update drivers on google map
              updateAvailableNearbyOnlineDriversOnMap();
            }
            break;
          case Geofire.onKeyExited:
            ManageDriversMethods.removeDriverFromList(driverEvent["key"]);
            //update drivers on google map
            updateAvailableNearbyOnlineDriversOnMap();

            break;

          case Geofire.onKeyMoved:
            OnlineNearbyDrivers onlineNearbyDrivers = OnlineNearbyDrivers();
            onlineNearbyDrivers.uidDriver = driverEvent["key"];
            onlineNearbyDrivers.latDriver = driverEvent["latitude"];
            onlineNearbyDrivers.lngDriver = driverEvent["longitude"];
            ManageDriversMethods.updateOnlineNearbyDriversLocation(
                onlineNearbyDrivers);

            //update drivers on google map
            updateAvailableNearbyOnlineDriversOnMap();

            break;

          case Geofire.onGeoQueryReady:
            nearbyOnlineDriversKeysLoaded = true;

            //update drivers on google map
            updateAvailableNearbyOnlineDriversOnMap();
            break;
        }
      }
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

      var driverLocation =
          (eventSnapshot.snapshot.value as Map)["driverLocation"] as Map?;

      if (driverLocation != null) {
        if (driverLocation["latitude"] != null &&
            driverLocation["longitude"] != null) {
          double driverLatitude =
              double.parse(driverLocation["latitude"].toString());
          double driverLongitude =
              double.parse(driverLocation["longitude"].toString());
          LatLng driverCurrentLocationLatLng =
              LatLng(driverLatitude, driverLongitude);

          if (status == "accepted") {
            if (!isTripDetailsContainerDisplayed) {
              displayTripDetailsContainer();
              isTripDetailsContainerDisplayed = true;
            }

            Geofire.stopListener();

            // Remove driver's markers
            setState(() {
              markerSet.removeWhere(
                  (element) => element.markerId.value.contains("driver"));
            });
            //update info for pickup to user on UI
            //info from driver current location to user pickup location
            // Update info for pickup to user on UI
            // Info from driver current location to user pickup location
            updateFromDriverCurrentLocationToPickUp(
                driverCurrentLocationLatLng);
          } else if (status == "arrived") {
            // Update info for arrived - when driver reaches the pickup point of the user
            setState(() {
              tripStatusDisplay = 'Driver has Arrived';
            });
          } else if (status == "ontrip") {
            // Update info for dropoff to user on UI
            // Info from driver current location to user dropoff location
            updateFromDriverCurrentLocationToDropOffDestination(
                driverCurrentLocationLatLng);
          }
        }
      }
      // if (status == "accepted") {

      // }

      if (status == "ended") {
        if ((eventSnapshot.snapshot.value as Map)["fareAmount"] != null) {
          double fareAmount = double.parse(
              (eventSnapshot.snapshot.value as Map)["fareAmount"].toString());

          var responseFromPaymentDialog = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                PaymentDialog(fareAmount: fareAmount.toString()),
          );
          if (responseFromPaymentDialog == "paid") {
            tripRequestRef!.onDisconnect();
            tripRequestRef = null;

            tripStreamSubscription!.cancel();
            tripStreamSubscription = null;

            resetAppNow();

            Restart.restartApp();
          }
        }
      }
    });
  }
StreamController<String> tripStatusDisplayController = StreamController<String>.broadcast();

 


 void displayTripDetailsContainer() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white24,
              blurRadius: 15.0,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              // Trip status display text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<String>(
                    stream: tripStatusDisplayController.stream,
                    initialData: tripStatusDisplay,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 19),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      photoDriver == ''
                          ? "https://firebasestorage.googleapis.com/v0/b/myapiprojects-425308.appspot.com/o/drivericon.png?alt=media&token=06d831a7-7b31-42f4-996d-9412a922b368"
                          : photoDriver,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameDriver,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        carDetailsDriver,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 19),
              const Divider(
                height: 1,
                color: Colors.white70,
                thickness: 1,
              ),
              const SizedBox(height: 19),
              // Call driver button
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse("tel://$phoneNumberDriver"));
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
updateFromDriverCurrentLocationToPickUp(driverCurrentLocationLatLng) async {
  if (!requestingDirectionDetailsInfo) {
    requestingDirectionDetailsInfo = true;

    var userPickUpLocationLatLng = LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    var directionDetailsPickup = await CommonMethods.getDirectionDetailsFromAPI(
        driverCurrentLocationLatLng, userPickUpLocationLatLng);

    if (directionDetailsPickup == null) {
      return;
    }

    tripStatusDisplayController.add("Driver is Coming - ${directionDetailsPickup.durationTextString}");

    requestingDirectionDetailsInfo = false;
  }
}

updateFromDriverCurrentLocationToDropOffDestination(driverCurrentLocationLatLng) async {
  if (!requestingDirectionDetailsInfo) {
    requestingDirectionDetailsInfo = true;

    var dropOffLocation = Provider.of<AppInfo>(context, listen: false).dropOffLocation;
    var userDropOffLocationLatLng = LatLng(dropOffLocation!.latitudePosition!, dropOffLocation.longitudePosition!);

    var directionDetailsPickup = await CommonMethods.getDirectionDetailsFromAPI(
        driverCurrentLocationLatLng, userDropOffLocationLatLng);

    if (directionDetailsPickup == null) {
      return;
    }

    tripStatusDisplayController.add("Driving to DropOff Location\n- ${directionDetailsPickup.durationTextString}");

    requestingDirectionDetailsInfo = false;
  }
}


  noDriverAvailable() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => InfoDialog(
              title: "No Driver Available".tr(),
              description:
                  "No driver found in the nearby location. Please try again shortly.".tr(),
            ));
  }

  searchDriver() {
    if (availableNearbyOnlineDriversList!.length == 0) {
      cancelRideRequest();
      resetAppNow();
      noDriverAvailable();
      return;
    }

    var currentDriver = availableNearbyOnlineDriversList![0];

    //send notification to this currentDriver - currentDriver means selected driver
    sendNotificationToDriver(currentDriver);

    availableNearbyOnlineDriversList!.removeAt(0);

    print(
        "Current Driver ID:========================== ${currentDriver.uidDriver}");
  }

  sendNotificationToDriver(OnlineNearbyDrivers currentDriver) {
    //update driver's newTripStatus - assign tripID to current driver
    DatabaseReference currentDriverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentDriver.uidDriver.toString())
        .child("newTripStatus");

    currentDriverRef.set(tripRequestRef!.key);

    //get current driver device recognition token
    DatabaseReference tokenOfCurrentDriverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentDriver.uidDriver.toString())
        .child("deviceToken");

    tokenOfCurrentDriverRef.once().then((dataSnapshot) {
      if (dataSnapshot.snapshot.value != null) {
        String deviceToken = dataSnapshot.snapshot.value.toString();

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
        // if(stateOfApp != "requesting")
        // {
        //   timer.cancel();
        //   currentDriverRef.set("cancelled");
        //   currentDriverRef.onDisconnect();
        //   requestTimeoutDriver = 20;
        // }

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
          searchDriver();
        }
      });
    });
  }

  void _animate() {
    setState(() {
      animationValue = animationValue == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    makeDriverNearbyCarIcon();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
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
              });

              getCurrentLiveLocationOfUser();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var responseFromSearchPage = await Navigator.push(context,
              MaterialPageRoute(builder: (c) => const SearchDestinationPage()));
          if (responseFromSearchPage == "placeSelected") {
            displayUserRideDetailsContainer();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 22, 60),
        child: const Icon(
          Icons.location_on_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
