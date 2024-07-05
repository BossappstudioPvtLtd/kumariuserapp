import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String locationMessage = "";

  @override
  void initState() {
    super.initState();
     getCurrentLocation() ;
  }

  Future<String> getCurrentLocation() async {
  // Get the current position
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // Get the placemarks from coordinates
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks[0];

    // Format the address according to the requirement
    String locationMessage = '${place.name}, ${place.street}, ${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
    
    return locationMessage;
    
  } else {
    return 'No location found';
  }
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Name Display'),
      ),
      body: Center(
        child: Text(locationMessage),
      ),
    );
  }
}
