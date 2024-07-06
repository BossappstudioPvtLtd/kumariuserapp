import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  BitmapDescriptor? carIconNearbyDriver;
  final Set<Marker> _markers = {};

  void makeDriverNearbyCarIcon() {
    if (carIconNearbyDriver == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(
        context,
        size: const Size(48, 48), // Specify pixel size instead of fraction size
      );
      BitmapDescriptor.fromAssetImage(
        configuration,
        "assets/images/transport.png",
      ).then((iconImage) {
        setState(() {
          carIconNearbyDriver = iconImage;
          _addMarker();
        });
      });
    } else {
      _addMarker();
    }
  }

  void _addMarker() {
    if (carIconNearbyDriver != null) {
      Marker marker = Marker(
        markerId: MarkerId('carIconNearbyDriver'),
        position: LatLng(37.7749, -122.4194), // Example coordinates, replace with actual position
        icon: carIconNearbyDriver!,
        onTap: () {
          print('haii');
        },
      );
      setState(() {
        _markers.add(marker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Example'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // Example coordinates
              zoom: 14,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                makeDriverNearbyCarIcon();
              },
              child: Text('Create Car Icon'),
            ),
          ),
        ],
      ),
    );
  }
}
