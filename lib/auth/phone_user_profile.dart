// ignore_for_file: unused_element, deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhoneUserProfile extends StatefulWidget {
  const PhoneUserProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  PhoneUserProfileState createState() => PhoneUserProfileState();
}

class PhoneUserProfileState extends State<PhoneUserProfile> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;
  User? user = FirebaseAuth.instance.currentUser;

  String? userEmail;
  String? userName;
  User? currentUser;
  File? _imageFile;

  @override
  void initState() {
    fetchPhoneNumbers();
    if (user != null) {
      userEmail = user!
          .email; // Assuming the user is logged in using email and password
      userName = user!.displayName;
      currentUser =
          _auth.currentUser; // Assuming the user has a display name set up
    }

    super.initState();
  }

  Future<Map<String, dynamic>> fetchPhoneNumbers() async {
    User? currentUser = _auth.currentUser;
    String uid = currentUser?.uid ?? '';

    // Fetch from Firestore
    var firestoreData = await _firestore.collection('User').doc(uid).get();
    String PhoneNumber =
        firestoreData.data()?['phone'] ?? ' phone number not  available ';

    return {
      'Firestore': PhoneNumber,
    };
  }
  //user/email/phone Number

  // Function to upload image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    String fileName =
        'user_images/${currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}';
    Reference ref = _storage.ref().child(fileName);
    await ref.putFile(_imageFile!);
    String imageUrl = await ref.getDownloadURL();
    await currentUser!.updatePhotoURL(imageUrl);
  }

  // Function to update user profile information
  Future<void> _updateUserProfile(
      String displayName, String email, String phoneNumber) async {
    // Update display name and email
    await currentUser!.updateDisplayName(displayName);

    await currentUser!.updateEmail(email);
    //await currentUser!.updatePhoneNumber(phoneNumber as PhoneAuthCredential);
    // Update phone number (requires verification)
    // Note: Implement phone number verification logic as per your app's requirements
    // ...

    // Upload image and update photo URL
    await _uploadImage();

    // Reload user to apply changes
    await currentUser!.reload();
    currentUser = _auth.currentUser;
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
     showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Update Your Profile..."),
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
    await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    Navigator.pop(context);
    _addDataToFirestore(user);
    _addDataToRealtimeDatabase(user);
  }

  void _addDataToFirestore(User? user) {
    _firestore.collection('User').doc(user!.uid).set({
      'phone': _phoneController.text,
      'name': _usernameController.text,
      'Email': _emailController.text,
      "id": user.uid,
      "blockStatus": "no",

      // Add other user data here
    });
  }

  void _addDataToRealtimeDatabase(User? user) {
    _realtimeDatabase.reference().child('User').child(user!.uid).set({
      'phone': _phoneController.text,
      'name': _usernameController.text,
      'email':_emailController.text,
      "id": user.uid,
      "blockStatus": "no",

      // Add other user data here
    });
  }

  @override
  Widget build(BuildContext context) {
    _usernameController.text = "$userName";
    _emailController.text = "$userEmail";
    _phoneController.text = "xxxxxxxxxx";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile editing"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: fetchPhoneNumbers(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return ListView(
                children: <Widget>[
                  Column(
                    children: [
                      ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (_imageFile == null)
                            Container()
                          else
                            Material(
                              elevation: 20,
                              borderRadius: BorderRadius.circular(100.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                                  _imageFile!,
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 30,
                        width: 150,
                        child: Center(child: Text("Add your profile")),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(100.0),
                            child: IconButton(
                              icon: const Icon(Icons.photo_camera),
                              onPressed: () async => _pickImageFromCamera(),
                              tooltip: 'Shoot picture',
                            ),
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(100.0),
                            child: IconButton(
                              icon: const Icon(Icons.photo),
                              onPressed: () async => _pickImageFromGallery(),
                              tooltip: 'Pick from gallery',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10.0),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelText: 'User Name',
                                  hintText: '$userName',
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Icon(Icons.person),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(Icons.email_outlined),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                labelText: "Email",
                                hintText: '$userEmail',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Icon(Icons.phone_android_rounded),
                                  ),
                                  labelText: 'Phone Number',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: snapshot.data?['Firestore'] ??
                                      'Not found'),
                            ),
                          ),
                          const SizedBox(height: 50),
                          MaterialButtons(
                            borderRadius: BorderRadius.circular(10),
                            meterialColor: const Color.fromARGB(255, 3, 22, 60),
                            containerheight: 50,
                            elevationsize: 20,
                            textcolor: Colors.white,
                            fontSize: 18,
                            textweight: FontWeight.bold,
                            text: "Submit",
                            onTap: () {
                             
                             fetchPhoneNumbers();
                             // _signInWithGoogle();
                              _updateUserProfile(
                                _usernameController.text,
                                _emailController.text,
                                _phoneController.text,
                              );
                               
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }
}
