import 'dart:async';
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
import 'package:new_app/Models/direction_deteils.dart';
import 'package:new_app/Models/info_dialoge.dart';
import 'package:new_app/Models/online_earby_drivers.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/comen/manage_drivers_methods.dart';
import 'package:new_app/comen/push_notification.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/splashripple.dart';
import 'package:new_app/navigatinbar/botton_navigtion.dart';

import 'package:new_app/search_destination.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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

  double animationValue = 0; // Initial animation value

  makeDriverNearbyCarIcon() {
    if (carIconNearbyDriver == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context,
          size: const Size(0.10, 0.10)); // Smaller size
      BitmapDescriptor.fromAssetImage(
        configuration,
        "assets/images/placeholder(1).png",
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

  retrieveDirectionDetails() async 
  {
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
          LoadingDialog(messageText: "Getting direction..."),
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
     // Restart.restartApp();
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
        markerId: MarkerId(
            "driver ID = " + eachOnlineNearbyDriver.uidDriver.toString()),
        position: driverCurrentPosition,
        icon: carIconNearbyDriver!,
      );

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
    }

    noDriverAvailable() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => InfoDialog(
                title: "No Driver Available",
                description:
                    "No driver found in the nearby location. Please try again shortly.",
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
    }

    sendNotificationToDriver(OnlineNearbyDrivers currentDriver)
  {
    //update driver's newTripStatus - assign tripID to current driver
    DatabaseReference currentDriverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentDriver.uidDriver.toString())
        .child("newTripStatus");

    currentDriverRef.set(tripRequestRef!.key);
    
    print('value is 1----------------- $currentDriverRef');
    //get current driver device recognition token
    DatabaseReference tokenOfCurrentDriverRef = FirebaseDatabase.instance
    
    
        .ref()
        .child("drivers")
        .child(currentDriver.uidDriver.toString())
        .child("deviceToken");

    tokenOfCurrentDriverRef.once().then((dataSnapshot)

    {
      
      
      if(dataSnapshot.snapshot.value != null)
      
      {
        String deviceToken = dataSnapshot.snapshot.value.toString();

    print('value is 2----------------- $deviceToken');
        //send notification
          PushNotificationService.sendNotificationToSelectedDriver(
            deviceToken,
            context,
            tripRequestRef!.key.toString()
        );
      }
      else
      {
         return;
      }
      const oneTickPerSec = Duration(seconds :1);
      var timerCountDown = Timer.periodic(oneTickPerSec, (timer)
      {
         requestTimeoutDriver = requestTimeoutDriver -1;

         if(stateOfApp != "requesting")
         {
          timer.cancel();
          currentDriverRef.onDisconnect();
          requestTimeoutDriver =20;
         }

        currentDriverRef.onValue.listen((dataSnapshot)
        {
          if (dataSnapshot.snapshot.value.toString() == "accepted")
          {
            timer.cancel();
            currentDriverRef.onDisconnect();
            requestTimeoutDriver = 20;
          }

        });
        if (requestTimeoutDriver == 0)
        {
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
