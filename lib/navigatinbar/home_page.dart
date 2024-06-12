import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_app/auth/login_page.dart';
//import 'package:new_app/navigatinbar/botton_navigtion.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(8.0844, 77.5495),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[];
  String userName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserInfoAndCheckBlockStatus();
    initializeGeoFireListener();
    getUserCurrentLocation().then((value) async {
      debugPrint("${value.latitude} ${value.longitude}");
      _markers.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: const InfoWindow(
          title: 'My Current Location',
        ),
      ));

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      )));
    });
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You are blocked. Contact admin: Kumariacabs@gmail.com")));
      }
    } else {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const LoginScreen()));
    }
  }

  void initializeGeoFireListener() {
    // Your logic for GeoFire listener goes here
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      debugPrint("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGoogle,
          markers: Set<Marker>.of(_markers),
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
