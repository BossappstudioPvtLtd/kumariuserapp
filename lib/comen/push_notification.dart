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

