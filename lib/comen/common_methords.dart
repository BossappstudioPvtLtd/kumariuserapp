import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Appinfo/app_info.dart';
import '../Const/global_var.dart';
import '../Models/direction_deteils.dart';
import '../locatio Auto Fill/model/add_model.dart';

class CommonMethods {
  checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaySnackBar(
          "your Internet is not Available. Check your connection. Try Again.",
          context);
    }
  }

  displaySnackBar(String messageText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static sendRequestToAPI(String apiUrl) async {
    http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));

    try {
      if (responseFromAPI.statusCode == 200) {
        String dataFromApi = responseFromAPI.body;
        var dataDecoded = jsonDecode(dataFromApi);
        return dataDecoded;
      } else {
        return "error";
      }
    } catch (errorMsg) {
      return "error";
    }
  }

  ///Reverse GeoCoding
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

  ///Directions API
  static Future<DirectionDetails?> getDirectionDetailsFromAPI(
      LatLng source, LatLng destination) async {
    String urlDirectionsAPI =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${destination.latitude},${destination.longitude}&origin=${source.latitude},${source.longitude}&mode=driving&key=$googleMapKey";

    var responseFromDirectionsAPI = await sendRequestToAPI(urlDirectionsAPI);

    if (responseFromDirectionsAPI == "error") {
      return null;
    }

    DirectionDetails detailsModel = DirectionDetails();

    detailsModel.distanceTextString =responseFromDirectionsAPI["routes"][0]["legs"][0]["distance"]["text"];
    detailsModel.distanceValueDigits =responseFromDirectionsAPI["routes"][0]["legs"][0]["distance"]["value"];

    detailsModel.durationTextString =responseFromDirectionsAPI["routes"][0]["legs"][0]["duration"]["text"];
    detailsModel.durationValueDigits =responseFromDirectionsAPI["routes"][0]["legs"][0]["duration"]["value"];
   
   detailsModel.encodedPoints =responseFromDirectionsAPI["routes"][0]["overview_polyline"]["points"];

    return detailsModel;
  }

  ///Directions API
  /*calculateFareAmount(DirectionDetails directionDetails)
  {
    double distancePerKmAmount = 2.0;
    double durationPerMinuteAmount = 0.3;
    double baseFareAmount = 2;

    double totalDistanceTravelFareAmount = (directionDetails.distanceValueDigits! / 100) * distancePerKmAmount;
    double totalDurationSpendFareAmount = (directionDetails.durationValueDigits! / 60) * durationPerMinuteAmount;

    double overAllTotalFareAmount = baseFareAmount + totalDistanceTravelFareAmount + totalDurationSpendFareAmount;

    return overAllTotalFareAmount.toStringAsFixed(1);
  }*/

  String calculateFareAmountFor3Seats(DirectionDetails directionDetails) {
    double distancePerKmAmount = .6;
    double durationPerMinuteAmount = 0.3;
    double baseFareAmount = 30;

    // Assuming the fare calculation is influenced by the number of seats
    double seatFactor = 3; // For 3 seats

    double totalDistanceTravelFareAmount =
        (directionDetails.distanceValueDigits! / 1000) * distancePerKmAmount;
    double totalDurationSpendFareAmount =
        (directionDetails.durationValueDigits! / 60) * durationPerMinuteAmount;

    double overAllTotalFareAmount = baseFareAmount +
        (totalDistanceTravelFareAmount + totalDurationSpendFareAmount) *
            seatFactor;

    return overAllTotalFareAmount.toStringAsFixed(1);
  }

  String calculateFareAmountFor4Seats(DirectionDetails directionDetails) {
    double distancePerKmAmount = .6;
    double durationPerMinuteAmount = 0.3;
    double baseFareAmount = 50;

    // Assuming the fare calculation is influenced by the number of seats
    double seatFactor = 4; // For 4 seats

    double totalDistanceTravelFareAmount =
        (directionDetails.distanceValueDigits! / 1000) * distancePerKmAmount;
    double totalDurationSpendFareAmount =
        (directionDetails.durationValueDigits! / 60) * durationPerMinuteAmount;

    double overAllTotalFareAmount = baseFareAmount +
        (totalDistanceTravelFareAmount + totalDurationSpendFareAmount) *
            seatFactor;

    return overAllTotalFareAmount.toStringAsFixed(1);
  }

  String calculateFareAmountFor7Seats(DirectionDetails directionDetails) {
    double distancePerKmAmount = .8;
    double durationPerMinuteAmount = 0.3;
    double baseFareAmount = 80;

    // Assuming the fare calculation is influenced by the number of seats
    double seatFactor = 7; // For 7 seats

    double totalDistanceTravelFareAmount =
        (directionDetails.distanceValueDigits! / 1000) * distancePerKmAmount;
    double totalDurationSpendFareAmount =
        (directionDetails.durationValueDigits! / 60) * durationPerMinuteAmount;

    double overAllTotalFareAmount = baseFareAmount +
        (totalDistanceTravelFareAmount + totalDurationSpendFareAmount) *
            seatFactor;

    return overAllTotalFareAmount.toStringAsFixed(1);
  }

  calculateFareAmount(DirectionDetails directionDetails) {}
}
