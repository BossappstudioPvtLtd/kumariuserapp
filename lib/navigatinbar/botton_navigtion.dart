// ignore_for_file: unused_element, deprecated_member_use, prefer_is_empty
import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/Models/direction_deteils.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/prediction_model.dart';
import 'package:new_app/navigatinbar/chat_page.dart';
import 'package:new_app/navigatinbar/favorite_page.dart';
import 'package:new_app/navigatinbar/home_page.dart';
import 'package:new_app/navigatinbar/profile_page.dart';
import 'package:new_app/search_destination.dart';
import 'package:provider/provider.dart';

import '../Appinfo/app_info.dart';

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
DirectionDetails? tripDirectionDetailsInfo;

//DirectionDetails? tripDirectionDetailsInfo;

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

  displayUserRideDetailsContainer() async {
    ///Directions API
    await retrieveDirectionDetails();

    setState(() {
      searchContainerHeight = 0;
      bottomMapPadding = 240;
      rideDetailsContainerHeight = 242;
    });
  }

  retrieveDirectionDetails() async {
    var pickUpLocation = Provider.of<AppInfo>(context, listen: false).pickUpLocation;
    var dropOffDestinationLocation =Provider.of<AppInfo>(context, listen: false).dropOffLocation;
    var pickupGeoGraphicCoOrdinates = LatLng( pickUpLocation!.latitudePosition!, pickUpLocation.longitudePosition!);
    var dropOffDestinationGeoGraphicCoOrdinates = LatLng( dropOffDestinationLocation!.latitudePosition!,dropOffDestinationLocation.longitudePosition!);
   showDialog(
      barrierDismissible: false,context: context,builder: (BuildContext context) => LoadingDialog(messageText: "Getting direction..."),);
    Navigator.pop(context);
///Directions API
    var detailsFromDirectionAPI =await CommonMethods.getDirectionDetailsFromAPI(
            pickupGeoGraphicCoOrdinates,
            dropOffDestinationGeoGraphicCoOrdinates);

    setState(() {
      tripDirectionDetailsInfo = detailsFromDirectionAPI;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var responseFromSearchPage = await Navigator.push(context,
              MaterialPageRoute(builder: (c) => const SearchDestinationPage()));

          if (responseFromSearchPage == "placeSelected") {
            // String dropOffLocation = Provider.of<AppInfo>(context, listen: false) .dropOffLocation!.placeName ?? ""; debugPrint("dropOffLocation = $dropOffLocation");
            displayUserRideDetailsContainer();
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
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: SizedBox(
                                height: 190,
                                child: Card(
                                    elevation: 10,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .90,
                                      color: Colors.black45,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    (tripDirectionDetailsInfo !=
                                                            null)
                                                        ? tripDirectionDetailsInfo!
                                                            .distanceTextString!
                                                        : "",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    (tripDirectionDetailsInfo !=
                                                            null)
                                                        ? tripDirectionDetailsInfo!
                                                            .durationTextString!
                                                        : "",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        height: 122,
                                                        width: 80,
                                                      ),
                                                    ),
                                                     Text(
                                                      
                                                     (tripDirectionDetailsInfo != null) ? "₹ ${(cMethods.calculateFareAmountFor3Seats(tripDirectionDetailsInfo!)).toString()}" : "",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        height: 122,
                                                        width: 100,
                                                      ),
                                                    ),
                                                     Text(
                                                    
                                                      (tripDirectionDetailsInfo != null) ? "₹ ${(cMethods.calculateFareAmountFor4Seats(tripDirectionDetailsInfo!)).toString()}" : "",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        height: 122,
                                                        width: 100,
                                                      ),
                                                    ),
                                                     Text(
                                                     
                                                     (tripDirectionDetailsInfo != null) ? "₹ ${(cMethods.calculateFareAmountFor7Seats(tripDirectionDetailsInfo!)).toString()}" : "",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                         
                                        ),
                                      ),
                                    )),
                              ),
                            ),

                           // SliderButton1()
                          ],
                        ),
                      ),
                    ),
                  );
                });
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
