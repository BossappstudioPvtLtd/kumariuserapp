//import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/components/my_textfield.dart';
import 'package:new_app/components/user_datanav.dart';
import 'package:new_app/locatio%20Auto%20Fill/Widgets/prediction_place.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/prediction_model.dart';
import 'package:new_app/navigatinbar/profile_page.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

TextEditingController pickUpTextEditingController = TextEditingController();
TextEditingController destinationTextEditingController =
    TextEditingController();
List<PredictionModel> dropOffPredictionsPlacesList = [];

final FirebaseAuth _auth = FirebaseAuth.instance;
CommonMethods cMethods = CommonMethods();
double searchContainerHeight = 276;
double bottomMapPadding = 0;
double rideDetailsContainerHeight = 0;

//DirectionDetails? tripDirectionDetailsInfo;

//User? user = FirebaseAuth.instance.currentUser;
String? userEmail;
String? userName;
//User? currentUser;

class _SearchDestinationPageState extends State<SearchDestinationPage> {
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

  final _locatioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _locatioController.text = _locationMessage;
    
    return Scaffold(
      backgroundColor: Colors.amber,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 10,
              ),
              child: UserInfoNav(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(5),
                        child: Form(
                          child: TextFormField(
                            controller: destinationTextEditingController,
                            onChanged: (inputText) {
                              searchLocation(inputText);
                            },
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: "Search Your Destination".tr(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(255, 92, 240, 253),
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
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 25.0),
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: const Center(
                /* child: Row(
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
                            ),*/
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 4,
              thickness: 4,
              color: Colors.white70,
            ),
          ),
          //display prediction results for destination place
          (dropOffPredictionsPlacesList.isNotEmpty)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return PredictionPlaceUI(
                        predictedPlaceData: dropOffPredictionsPlacesList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 2,
                    ),
                    itemCount: dropOffPredictionsPlacesList.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                )
              : Container(),

          
        ],
      ),
    );
  }
}
