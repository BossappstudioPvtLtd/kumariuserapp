import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/locatio%20Auto%20Fill/Widgets/prediction_place.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/add_model.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/prediction_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  SearchDestinationPageState createState() => SearchDestinationPageState();
}

class SearchDestinationPageState extends State<SearchDestinationPage>
  with WidgetsBindingObserver {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController =TextEditingController();
  List<PredictionModel> dropOffPredictionsPlacesList = [];
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 1000;
  String userName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUsername();
    _getUserAddress();
  }

  Future<void> _getUserAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String address = await convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
        position, context);
    setState(() {
      pickUpTextEditingController.text = address;
    });
  }

  static Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
      Position position, BuildContext context) async {
    String humanReadableAddress = "";
    String apiGeoCodingUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleMapKey";

    var responseFromAPI = await sendRequestToAPI(apiGeoCodingUrl);

    if (responseFromAPI != "error") {
      humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];

      AddressModel model = AddressModel();
      model.humanReadableAddress = humanReadableAddress;
      model.placeName = humanReadableAddress;
      model.longitudePosition = position.longitude;

      model.latitudePosition = position.latitude;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(model);
    }
    return humanReadableAddress;
  }

  static Future<dynamic> sendRequestToAPI(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  void searchLocation(String locationName) async {
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
        debugPrint("predictionResultInjson =$predictionResultInJson");
      }
    }
  }

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

  Future<void> getUsername() async {
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            //  padding: EdgeInsets.only(top: 26, bottom: bottomMapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              googleMapCompleterController.complete(controllerGoogleMap);
              setState(() {});
              getCurrentLiveLocationOfUser();
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: searchContainerHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 70,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hi There".tr(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "Where to?".tr(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Material(
                            elevation: 20,
                            borderRadius: BorderRadius.circular(5),
                            child: Form(
                              child: TextFormField(
                                controller: pickUpTextEditingController,
                                textInputAction: TextInputAction.search,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Icon(Icons.my_location_outlined,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material(
                            elevation: 20,
                            borderRadius: BorderRadius.circular(5),
                            child: Form(
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                controller: destinationTextEditingController,
                                onChanged: (inputText) {
                                  searchLocation(inputText);
                                },
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  suffixStyle:
                                      const TextStyle(color: Colors.white),
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  fillColor: Colors.grey.shade600,
                                  filled: true,
                                  hintText: "Search Your Destination".tr(),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Icon(Icons.search_rounded,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          (dropOffPredictionsPlacesList.isNotEmpty)
                              ? ListView.separated(
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return PredictionPlaceUI(
                                      predictedPlaceData:
                                          dropOffPredictionsPlacesList[index],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(height: 2),
                                  itemCount:
                                      dropOffPredictionsPlacesList.length,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                )
                              : Container(),
                          /* GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Search Drop Off Location",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
