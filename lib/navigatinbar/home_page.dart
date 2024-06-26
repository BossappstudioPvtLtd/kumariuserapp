import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/Const/trip_var.dart';
import 'package:new_app/Models/direction_deteils.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/splashripple.dart';
import 'package:new_app/navigatinbar/botton_navigtion.dart';
import 'package:new_app/new_test.dart';

import 'package:new_app/search_destination.dart';
import 'package:provider/provider.dart';

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
  double animationValue = 0; // Initial animation value

  makeDriverNearbyCarIcon() {
    if (carIconNearbyDriver == null) {
      ImageConfiguration configuration =
          createLocalImageConfiguration(context, size: Size(0.5, 0.5));
      BitmapDescriptor.fromAssetImage(
              configuration, "assets/images/tracking.png")
          .then((iconImage) {
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
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserInfoAndCheckBlockStatus();

    // initializeGeoFireListener();
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
          userName = userData["name"];
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
      rideDetailsContainerHeight = 400;
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

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: rideDetailsContainerHeight,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: SizedBox(
                        height: 300,
                        child: Card(
                            elevation: 10,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .90,
                              color: Colors.black45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              resetAppNow();
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text("Cancel ")),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                // Navigate to the SplashRipple page
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const SpalshRipple()),
                                                );

                                                // Code here will execute when returning from SplashRipple page
                                                resetAppNow(); // Reset the app state
                                                cancelRideRequest();

                                                Navigator.of(context).pop(
                                                    false); // Cancel any ride requests or similar tasks
                                              },
                                              child: const Text("GO"),
                                            )),
                                        //resetAppNow();
                                        //  cancelRideRequest();
                                        //SliderButton1()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
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

  /* updateAvailableNearbyOnlineDriversOnMap() {
    setState(() {
      markerSet.clear();
    });

    Set<Marker> markersTempSet = Set<Marker>();

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
  }*/

  void _animate() {
    setState(() {
      animationValue = animationValue == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
