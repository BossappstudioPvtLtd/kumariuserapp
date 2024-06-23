import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/add_model.dart';
import 'package:provider/provider.dart';
import 'package:new_app/Appinfo/app_info.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/components/my_textfield.dart';
import 'package:new_app/components/user_datanav.dart';
import 'package:new_app/locatio%20Auto%20Fill/Widgets/prediction_place.dart';
import 'package:new_app/locatio%20Auto%20Fill/model/prediction_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController = TextEditingController();
  List<PredictionModel> dropOffPredictionsPlacesList = [];

  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 276;
  double bottomMapPadding = 0;
  double rideDetailsContainerHeight = 0;

  @override
  void initState() {
    super.initState();
    _getUserAddress();
  }

  Future<void> _getUserAddress() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String address = await convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(position, context);
    setState(() {
      pickUpTextEditingController.text = address;
    });
  }

  static Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(Position position, BuildContext context) async {
    String humanReadableAddress = "";
    String apiGeoCodingUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleMapKey";

    var responseFromAPI = await sendRequestToAPI(apiGeoCodingUrl);

    if (responseFromAPI != "error") {
      humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];

      AddressModel model = AddressModel();
      model.humanReadableAddress = humanReadableAddress;
      model.longitudePosition = position.longitude;
      model.latitudePosition = position.latitude;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(model);
    }
    print('value is ----------------- $humanReadableAddress');
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
      String apiPlacesUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=$googleMapKey&components=country:in";

      var responseFromPlacesAPI = await CommonMethods.sendRequestToAPI(apiPlacesUrl);

      if (responseFromPlacesAPI == "error") {
        return;
      }

      if (responseFromPlacesAPI["status"] == "OK") {
        var predictionResultInJson = responseFromPlacesAPI["predictions"];
        var predictionsList = (predictionResultInJson as List)
            .map((eachPlacePrediction) => PredictionModel.fromJson(eachPlacePrediction))
            .toList();

        setState(() {
          dropOffPredictionsPlacesList = predictionsList;
        });
        debugPrint("predictionResultInjson =$predictionResultInJson");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
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
                    const SizedBox(height: 15),
                    MyTextField(
                      controller: pickUpTextEditingController,
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 7),
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
          const SizedBox(height: 10),
          (dropOffPredictionsPlacesList.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return PredictionPlaceUI(
                        predictedPlaceData: dropOffPredictionsPlacesList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 2),
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
