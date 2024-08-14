 import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;

String serverKeyFCM = "paste your key here";

//String googleMapKey = "AIzaSyCBWwWk9i5kaojtdXczvn3FrrCTeFqJojc";
String googleMapKey = "AIzaSyCjgUi8glFp2bvH-u2J_57klRqa_u79L98";



const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(8.088306,  77.538452),
  zoom: 14.4746,
);