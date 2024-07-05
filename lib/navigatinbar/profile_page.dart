// ignore_for_file: unused_element, non_constant_identifier_names, deprecated_member_use
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
    Position position = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() { _locationMessage ='${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}';});
  }

  User? currentUser = FirebaseAuth.instance.currentUser;
  DatabaseReference? userRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.black38,
                                    ),
                                    child: Image.asset(
                                      "assets/images/taxi.jpg",
                                      fit: BoxFit.cover,
                                     
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 120),
                                        child: MaterialButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            shape: const CircleBorder(),
                                            elevation: 0,
                                            child: Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => PrifileEdt(
                                                          name:"${data['name']}",
                                                          email:" ${data['email']}",
                                                          phone:"${data['phone']}",
                                                          photo:"${data['photo']}")));
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
                                      backgroundColor:
                                          const Color.fromARGB(255, 9, 77, 77),
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
                              child: Text(
                                "User Information".tr(),
                                style: TextStyle(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Card(
                              elevation: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                ),
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
                                              leading: Icon(
                                                Icons.my_location,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              title: Text("Location".tr()),
                                              subtitle: Text(
                                                _locationMessage,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.email,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              title: Text("Email".tr()),
                                              subtitle: Text(
                                                "${data['email']}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.phone_iphone_sharp,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              title: Text("Phone".tr()),
                                              subtitle: Text(
                                                "${data['phone']}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
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
