// ignore_for_file: body_might_complete_normally_catch_error, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/drewer/drawerhome.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameTextEditingController =
      TextEditingController();
  final TextEditingController userPhoneTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final CommonMethods cMethods = CommonMethods();
  bool passwordVisible = true;

  XFile? imageFile;
  String urlOfUploadedImage = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkIfNetworkIsAvailable() async {
    await cMethods.checkConnectivity(context);
    if (imageFile != null) {
      signUpFormValidation();
    } else {
      cMethods.displaySnackBar("Please choose image first.", context);
    }
  }

  void signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          "Your name must be at least 4 or more characters.", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please write a valid email.", context);
    } else if (userPhoneTextEditingController.text.trim().length < 10) {
      cMethods.displaySnackBar(
          "Your phone number must be at least 10 or more characters.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "Your password must be at least 6 or more characters.", context);
    } else {
      uploadImageToStorage();
    }
  }

  Future<void> uploadImageToStorage() async {
    final String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference referenceImage =
        FirebaseStorage.instance.ref().child("Images").child(imageIDName);
    final UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    final TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();

    setState(() {
      urlOfUploadedImage;
    });

    registerNewUser();
  }

  Future<void> registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering your account"),
    );

    try {
      final User? userFirebase =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ))
              .user;

      if (userFirebase != null) {
        final DatabaseReference usersRef = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userFirebase.uid);
        final Map<String, String> userDataMap = {
          "photo": urlOfUploadedImage,
          "name": userNameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": userPhoneTextEditingController.text.trim(),
          "id": userFirebase.uid,
          "blockStatus": "no",
        };
        await usersRef.set(userDataMap);

        // Sign out the user if blockStatus is "yes"
        if (userDataMap["blockStatus"] == "yes") {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          cMethods.displaySnackBar(
              "Your account has been blocked by the admin.", context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => const LoginScreen()));
          return;
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => const Drewer()));
        }
      }
    } catch (errorMsg) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMsg.toString(), context);
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> chooseImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          "Create a User's Account",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 5),
            imageFile == null
                ? Stack(
                    children: [
                      GestureDetector(
                        onTap: chooseImageFromGallery,
                        child: Material(
                          borderRadius: BorderRadius.circular(40),
                          elevation: 15,
                          child: const CircleAvatar(
                            radius: 43,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage("assets/images/user.jpg"),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60, left: 60),
                        child: InkWell(
                          onTap: chooseImageFromGallery,
                          child: Material(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(235, 1, 72, 130),
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(Icons.add_a_photo_rounded,
                                  size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Material(
                    elevation: 15,
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: FileImage(File(imageFile!.path)),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            const Text("Add your photo"),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  buildTextField(userNameTextEditingController, "User Name",
                      Icons.person, false),
                  const SizedBox(height: 22),
                  buildTextField(emailTextEditingController, "User Email",
                      Icons.email, false),
                  const SizedBox(height: 22),
                  buildTextField(userPhoneTextEditingController, "User Phone",
                      Icons.phone_android, false, TextInputType.phone),
                  const SizedBox(height: 22),
                  buildTextField(passwordTextEditingController, "Password",
                      Icons.lock, true),
                  const SizedBox(height: 32),
                  MaterialButtons(
                    borderRadius: BorderRadius.circular(10),
                    meterialColor: const Color.fromARGB(255, 3, 22, 60),
                    containerheight: 50,
                    elevationsize: 20,
                    textcolor: Colors.white,
                    fontSize: 18,
                    textweight: FontWeight.bold,
                    text: "Register",
                    onTap: checkIfNetworkIsAvailable,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an Account?",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                  child: const Text(
                    "Login Here",
                    style: TextStyle(color: Color.fromARGB(255, 1, 72, 130)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      IconData icon, bool isPassword,
      [TextInputType? keyboardType]) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && passwordVisible,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Icon(icon),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelText: labelText,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
