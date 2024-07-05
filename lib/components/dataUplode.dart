// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//import 'package:new_app/navigatinbar/favorite_page.dart';
//import 'package:new_app/navigatinbar/profile_page.dart';

class DataUp extends StatefulWidget {
  const DataUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataUpState createState() => _DataUpState();
}

class _DataUpState extends State<DataUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  User? currentUser;
  File? _imageFile;

  // Initialize state
  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  // Function to pick and set image
  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    String fileName = 'user_images/${currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}';
    Reference ref = _storage.ref().child(fileName);
    await ref.putFile(_imageFile!);
    String imageUrl = await ref.getDownloadURL();
    await currentUser!.updatePhotoURL(imageUrl);
  }

  // Function to update user profile information
  Future<void> _updateUserProfile(String displayName, String email, String phoneNumber) async {
    // Update display name and email
    await currentUser!.updateDisplayName(displayName);
    await currentUser!.updateEmail(email);

    // Update phone number (requires verification)
    // Note: Implement phone number verification logic as per your app's requirements
    // ...

    // Upload image and update photo URL
    await _uploadImage();

    // Reload user to apply changes
    await currentUser!.reload();
    currentUser = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingControllers to handle input
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display current user info
            if (currentUser != null) ...[
              Text('Current Username: ${currentUser!.displayName}'),
              Text('Current Email: ${currentUser!.email}'),
              // Display current user image
              currentUser!.photoURL != null
                  ? Image.network(currentUser!.photoURL!)
                  : const Placeholder(),
            ],
            // Input fields for new user info
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'New Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'New Phone Number'),
            ),
            // Button to pick new image
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            // Button to update user profile
            ElevatedButton(
              onPressed: () => _updateUserProfile(
                nameController.text,
                emailController.text,
                phoneController.text,
              ),
              
            
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

