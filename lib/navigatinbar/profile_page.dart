// ignore_for_file: unused_element, non_constant_identifier_names, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/navigatinbar/profile_edt.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
final ImagePicker _picker = ImagePicker();

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

String _locationMessage = "";
User? user = FirebaseAuth.instance.currentUser;
String? userEmail;
String? userName;
User? currentUser;
File? _imageFile;

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    _getCurrentLocation();

    super.initState();

    if (currentUser != null) {
      userRef = FirebaseDatabase.instance
          .reference()
          .child('users/${currentUser!.uid}');
    }
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

  User? currentUser = FirebaseAuth.instance.currentUser;
  DatabaseReference? userRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: currentUser == null || userRef == null
            ? const Center(child: Text('No user logged in'))
            : StreamBuilder(
                stream: userRef!.onValue,
                builder: (context, AsyncSnapshot event) {
                  if (event.hasData &&
                      !event.hasError &&
                      event.data.snapshot.value != null) {
                    Map data = event.data.snapshot.value;

                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Stack(
                                children: [
                                  Ink(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.black38,
                                    ),
                                    child: Image.asset(
                                      "assets/images/taxi.jpg",
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 120),
                                        child: MaterialButton(
                                            color: Colors.white,
                                            shape: const CircleBorder(),
                                            elevation: 0,
                                            child:  const Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                           PrifileEdt( name: "${data['name']}",
                                     email: " ${data['email']}",
                                      phone: "${data['phone']}",
                                     photo:  "${data['photo']}") ));
                                            }),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 160),
                                child: Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 42,
                                      backgroundColor: Color.fromARGB(255, 9, 77, 77),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.white,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Image.network(
                                                "${data['photo']}",
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            " ${data['name']}",
                            style: const TextStyle(fontSize: 20),
                          ),

                        
                          const SizedBox(height: 10.0),
                          Column(children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "User Information",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Card(
                              elevation: 10,
                              color: const Color.fromARGB(255, 236, 255, 255),
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        ...ListTile.divideTiles(
                                          color: Colors.grey,
                                          tiles: [
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              leading:
                                                  const Icon(Icons.my_location),
                                              title: const Text("Location"),
                                              subtitle: Text(
                                                _locationMessage,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.email),
                                              title: const Text("email"),
                                              subtitle:
                                                  Text("${data['email']}"),
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.phone_iphone_sharp),
                                              title: const Text("phone"),
                                              subtitle:
                                                  Text("${data['phone']}"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }));
  }
}
