import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;

String serverKeyFCM = "paste your key here";

//String googleMapKey = "AIzaSyCBWwWk9i5kaojtdXczvn3FrrCTeFqJojc";
String googleMapKey = "AIzaSyAzem3yZ5ZnNnmymCWaxfj37qKZ00HdfSg";

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);