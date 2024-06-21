// ignore_for_file: unused_element, deprecated_member_use, prefer_is_empty

import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/Appinfo/app_info.dart';
//import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/comen/common_methords.dart';
//import 'package:new_app/components/loading_dialog.dart';
//import 'package:new_app/components/m_buttons.dart';
//import 'package:new_app/components/my_textfield.dart';
//import 'package:new_app/components/splashripple.dart';
//import 'package:new_app/components/user_datanav.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/prediction_model.dart';
import 'package:new_app/navigatinbar/chat_page.dart';
import 'package:new_app/navigatinbar/favorite_page.dart';
import 'package:new_app/navigatinbar/home_page.dart';
import 'package:new_app/navigatinbar/profile_page.dart';
import 'package:new_app/search_destination.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

//import '../locatio Auto Fill/Widgets/prediction_place.dart';

class BottonNavigations extends StatefulWidget {
  const BottonNavigations({super.key});

  @override
  State<BottonNavigations> createState() => _BottonNavigationsState();
}

TextEditingController pickUpTextEditingController = TextEditingController();
TextEditingController destinationTextEditingController =
    TextEditingController();
List<PredictionModel> dropOffPredictionsPlacesList = [];

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
final ImagePicker _picker = ImagePicker();
CommonMethods cMethods = CommonMethods();
double searchContainerHeight = 276;
double bottomMapPadding = 0;
double rideDetailsContainerHeight = 0;

//DirectionDetails? tripDirectionDetailsInfo;

String _locationMessage = "";
//User? user = FirebaseAuth.instance.currentUser;
String? userEmail;
String? userName;
//User? currentUser;
File? _imageFile;

class _BottonNavigationsState extends State<BottonNavigations> {
  List<IconData> iconList = [
    Icons.home_outlined,
    Icons.message_outlined,
    Icons.favorite_outline_sharp,
    Icons.person_2_outlined
  ];
  List bottomPages = [
    const HomePage(),
    const ChatPage(),
    const Deatails(),
    const ProfilePage()
  ];

  int bottomNavInde = 0;

  String _locationMessage = "";
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
    if (user != null) {
      userEmail = user!
          .email; // Assuming the user is logged in using email and password
      userName = user!.displayName;
      currentUser =
          _auth.currentUser; // Assuming the user has a display name set up
    }
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _locationMessage =
          '${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}';
    });
  }

  ///Places API - Place AutoComplete
  searchLocation(String locationName) async {
    if (locationName.length > 1) {
      String apiPlacesUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=$googleMapKey&components=country:in";

      var responseFromPlacesAPI =
          await CommonMethods.sendRequestToAPI(apiPlacesUrl);

      if (responseFromPlacesAPI == "error") {
        return;
      }

      if (responseFromPlacesAPI["status"] == "OK") {
        var predictionResultInJson = responseFromPlacesAPI["predictions"];
        var predictionsList = (predictionResultInJson as List)
            .map((eachPlacePrediction) =>
                PredictionModel.fromJson(eachPlacePrediction))
            .toList();

        setState(() {
          dropOffPredictionsPlacesList = predictionsList;
        });
        debugPrint("predictioResultInjson =$predictionResultInJson");
      }
    }
  }

  displayUserRideDetailsContainer() {
    ///Directions API
    // await retrieveDirectionDetails();

    setState(() {
      searchContainerHeight = 0;
      bottomMapPadding = 240;
      rideDetailsContainerHeight = 242;
    });
  }

  ///Direction
  /*retrieveDirectionDetails()async{
    var pickupLocation = Provider.of<AppInfo>(context,listen: false).pickUpLocation;
    var dropOffDestinationLocation = Provider.of(context,listen: false).pickupLocation;

   var pickupGeoGraphicCoOrdinates = LatLng(pickupLocation!.latitudePosition!,pickupLocation. longitudePosition!);
    var dropOffDestinationGeoGraphicCoOrdinates = LatLng(dropOffDestinationLocation!.latitudePosition!, dropOffDestinationLocation.longitudePosition);
   showDialog(
      context: context, 
     builder: (BuildContext context )=> LoadingDialog(messageText: "Getting direction...")
      );
      var detailsFromDirectionAPI =await CommonMethods.getDirectionDetailsFromAPI(pickupGeoGraphicCoOrdinates,dropOffDestinationGeoGraphicCoOrdinates);
      setState(() {
       
      tripDirectionDetailsInfo = detailsFromDirectionAPI;
      });
  }*/

  final _locatioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _locatioController.text = _locationMessage;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var responseFromSearchPage = await Navigator.push(context,
              MaterialPageRoute(builder: (c) => const SearchDestinationPage()));

          if (responseFromSearchPage == "placeSelected") {
            String dropOffLocation =
                Provider.of<AppInfo>(context, listen: false)
                        .dropOffLocation!
                        .placeName ??
                    "";
            debugPrint("dropOffLocation = $dropOffLocation");
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        iconSize: 30,
        inactiveColor: Colors.white,
        icons: iconList,
        activeColor: Colors.grey.shade50,
        activeIndex: bottomNavInde,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) => setState(() => bottomNavInde = index),
        backgroundColor: const Color.fromARGB(255, 3, 22, 60),
      ),
      body: bottomPages[bottomNavInde],
    );
  }
}
