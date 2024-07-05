import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:new_app/Const/global_var.dart';
import 'package:provider/provider.dart';
import 'package:new_app/Appinfo/app_info.dart';

/// Updated in June 2024
/// This PushNotificationService only you have to update with below code for new FCM Cloud Messaging V1 API
class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "bossapp-9fba7",
      "private_key_id": "a446541ed0ebaa6d887b276476c3e3cdfeb5460a",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC6YM6wgG+pnlWe\nmU6YthvhzcuQsswfLZCG65qw72f6R5Tf5hxW3byGzXnm9UmcW7pW4osRYl72SUGM\nI1LTPdxBmSjgtXPEn9SxFcA5qBrrczUb+KTzk73Ou+UcL4AFTa5gl/VOhWzCv7Ay\nj8huQSfkspFGJGw0RfQ8xhDgZWWfXTdAvFa3nBVpC5PhAPgNMHYzXQyxq1ic8P+W\n3PS4w1KO3cV8xx5sN3yG+szTkADwX3M6OHsFdJekoOLpkddFbaFGc5g4zRw4soil\nueQJYWkALDQjUkiZv2TlQOh2L7KL264kzArSp3VA5KsODIYSufZSLUGMxFkoxvbD\ncDP/+fTdAgMBAAECggEABvpmarXYWG+w8Xf4eR/CYf0wTLnhCh7M3TxXhZ3lFPoW\noR5uu7LgIuTxFjxjVesaSjP/tHYsK4j5HwvYh0e25i7bmLQ6gidg0YOIt6/rWBrv\nZ11zIZqLvgCLdrdxkeFDcOLnoJm+xXjjWjVHchdW7MlhxpBJC9j9qMPasGgjeqi0\nsVUzWAVkAHziXHGgn3w+IXWrHwluM7nS/wKtl5uTEP+69cMwCVqOtk/bdAQsLP6M\nEaJlBUiAqxxOEXywur8/G6UBVPgCm7+/o55qP8g6D8CCbX/N4IF+nCgJJrwv0LE0\nz5+rNmX+2h4FM29UmWhrX4YdLPC04jwghoWzA5yFgQKBgQDi0ZHSBrbGtQRhMkq9\n3ZdDpc11lALLXdhoI3h7qv5TEufUmYQwN4sNkMzNB/ZQWNt620NwMPix8LRzTcHv\nS7avMs/5k5uQ60OJqQaPPMw8q7QNZxK9TMPODt1126j2moagIjTnNwzL+8ToOcwh\nsZE1m8jbxtNdxhp3hAFIwNHtgQKBgQDSW01l9/+R9OhA97EiXF68A0rUDJ8Btvf3\nHNUc0n4dFInipb5SYmmaZxVtiaaN9oLKNkWzCzPjcqr5635MI42yu8614zVKv0x5\ndVpF8AgH5RbsSJL4Dv99UCBiK2Ek2/fp509nNOvvL30nzJsn3okz5hk095az345K\n28ZKpnctXQKBgGNcFLnhkQ3I3EtLwawctxe+ORvpo7O8v4EXEL9z74cqv/3E5kBN\nBJADv4ONmlwmILdX99ncygUBAbuE85DFJRjodGzLOZmpReO29JWot3tYaD56yZ29\nVAUfQ+pOOF0W4iSh93TWC7gL6X0lXIPiCk9ml/2Wwp7QmmWCoSFivlOBAoGBALrE\nrfe3NYcV95CXWwKzGLm+ApY7joIrPgZ95wnsKmUPc01084KaNkEM/Y2ABg1Nrdp0\nTXYmoC92BDBZ0o0vlAP5lBMSZKK1LuU4OKqX78lyseOgnDz6tAVDOz1uXpYnZ/qZ\nkXqFFmYLuAe6NpgzkYYu6nqIyZlzCBeXAnwNSQtRAoGBAJCwkjAESOcIH6DVolYZ\nlpD8yt/Qhhh5UL+HBHHE8TKQJIS1dkbnwCjCYhm3oEAbfgHAwHbrgKjNHm2Knnxj\nr7Hlo8UADWE/NwCKiJlTNDGbygHUWXYT/MEBOLA6nzpZDxo/RwCJokZEMZyB7Fru\nkw1RCnmcDs5PlCEr1nm6RPbt\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-frixk@bossapp-9fba7.iam.gserviceaccount.com",
      "client_id": "101395357433042603616",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-frixk%40bossapp-9fba7.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final auth.ServiceAccountCredentials credentials =
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

    final auth.AccessCredentials accessCredentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            credentials, scopes, http.Client());

    return accessCredentials.accessToken.data;
  }

  Future<void> getUsername() async {
    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);
    final snap = await usersRef.once();
    if (snap.snapshot.value != null) {
      final userData = snap.snapshot.value as Map;
      userName = userData["name"];
    }
  }

  Future<String> getCurrentLocation() async {
    // Get the current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Get the placemarks from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];

      // Format the address according to the requirement
      String locationMessage = '${place.name}, ${place.street}, ${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
      
      return locationMessage;
    } else {
      return 'No location found';
    }
  }

  static Future<void> sendNotificationToSelectedDriver(
      String deviceToken, BuildContext context, String tripID) async {
    String dropOffDestinationAddress =Provider.of<AppInfo>(context, listen: false).dropOffLocation!.placeName.toString();
    


    String pickUpAddress = await PushNotificationService().getCurrentLocation();

    // Get the username
    await PushNotificationService().getUsername();


    print('Pick-up location: $pickUpAddress');
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/bossapp-9fba7/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          "title": "NET TRIP REQUEST from $userName",
          "body": "PickUp Location: $pickUpAddress \nDropOff Location: $dropOffDestinationAddress",
        },
        'data': {
          "tripID": tripID,
        },
      }
    };
        
    print('value is TRIP REQUEST from ----------------- $userName');
    print('value is PickUp Location----------------- $pickUpAddress');
    print('DropOff Location----------------- $dropOffDestinationAddress');

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }
}
