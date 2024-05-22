// ignore_for_file: unused_element, deprecated_member_use, prefer_is_empty

import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/comen/common_methords.dart';
//import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/components/my_textfield.dart';
import 'package:new_app/components/splashripple.dart';
import 'package:new_app/components/user_datanav.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/prediction_model.dart';
import 'package:new_app/navigatinbar/chat_page.dart';
import 'package:new_app/navigatinbar/favorite_page.dart';
import 'package:new_app/navigatinbar/home_page.dart';
import 'package:new_app/navigatinbar/profile_page.dart';
//import 'package:provider/provider.dart';

import '../locatio Auto Fill/Widgets/prediction_place.dart';

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
          var responseFromSearchPage = await showCupertinoModalPopup(
            context: context,
            builder: (builder) {
              return StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return ListView(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 10,
                          ),
                          child: UserInfoNav(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Card(
                          color: const Color.fromARGB(255, 3, 22, 60),
                          elevation: 20,
                          child: SizedBox(
                            height: 160,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                MyTextField(
                                  controller: _locatioController,
                                  icon: Icons.location_on,
                                  hintText: _locationMessage,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: Material(
                                    elevation: 20,
                                    borderRadius: BorderRadius.circular(5),
                                    child: Form(
                                      child: TextFormField(
                                        controller:
                                            destinationTextEditingController,
                                        onChanged: (inputText) {
                                          searchLocation(inputText);
                                        },
                                        textInputAction: TextInputAction.search,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Search Your Destination".tr(),
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Color.fromARGB(
                                                  255, 92, 240, 253),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 50.0,
                            disabledThumbRadius: 50,
                            elevation: 3,
                          ),
                          overlayColor: Colors.grey.withAlpha(32),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 25.0),
                          showValueIndicator: ShowValueIndicator.always,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MaterialButtons(
                                elevationsize: 2,
                                text: "Reset".tr(),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                containerheight: 50,
                                containerwidth: 150,
                                fontSize: 17,
                                textweight: FontWeight.bold,
                                textcolor: Colors.grey[500],
                                onTap: () {
                                  displayUserRideDetailsContainer();
                                },
                              ),
                              MaterialButtons(
                                elevationsize: 2,
                                text: "Apply".tr(),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                containerheight: 50,
                                containerwidth: 150,
                                fontSize: 17,
                                textweight: FontWeight.bold,
                                textcolor:
                                    Theme.of(context).colorScheme.onBackground,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SpalshRipple()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      /* const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          height: 4,
                          thickness: 4,
                          color: Colors.white70,
                        ),
                      ),*/

                      //display prediction results for destination place
                      (dropOffPredictionsPlacesList.length > 0)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListView.separated(
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 3,
                                    child: PredictionPlaceUI(
                                      predictedPlaceData:
                                          dropOffPredictionsPlacesList[index],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(
                                  height: 2,
                                ),
                                itemCount: dropOffPredictionsPlacesList.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                              ),
                            )
                          : Container(),

                      ///ride details container

                      Positioned(
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
                                color: Colors.white12,
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
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: SizedBox(
                                    height: 190,
                                    child: Card(
                                      elevation: 10,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .70,
                                        color: Colors.black,
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
                                                    const Text(
                                                      // (tripDirectionDetailsInfo != null) ? tripDirectionDetailsInfo!.distanceTextString! :
                                                      "2km",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      //(tripDirectionDetailsInfo != null) ? tripDirectionDetailsInfo!.durationTextString! :
                                                      "Your Destination kanyakumari",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Image.asset(
                                                          "assets/images/uberexec.png",
                                                          height: 50,
                                                          width: 50),
                                                    ),
                                                    const Text(
                                                      // (tripDirectionDetailsInfo != null) ? "\$ ${(cMethods.calculateFareAmount(tripDirectionDetailsInfo!)).toString()}" :
                                                      "",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
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
