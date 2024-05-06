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
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  bool passwordVisible = false;

  XFile? imageFile;
  String urlOfUploadedImage = "";

  @override
  void initState() {
    super.initState();

    passwordVisible = true;
  }

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    if (imageFile != null) //image validation
    {
      signUpFormValidation();
    } else {
      cMethods.displaySnackBar("Please choose image first.", context);
    }
  }

  signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          "your name must be atleast 4 or more characters.", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("please write valid email.", context);
    } else if (userPhoneTextEditingController.text.trim().length < 10) {
      cMethods.displaySnackBar(
          "your phone number must be atleast 10 or more characters.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "your password must be atleast 6 or more characters.", context);
    } else {
      uploadImageToStorage();
    }
  }

  uploadImageToStorage() async {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage =
        FirebaseStorage.instance.ref().child("Images").child(imageIDName);
    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();

    setState(() {
      urlOfUploadedImage;
    });

    registerNewUser();
  }

//loader
  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering your account"),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((errorMsg) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      "photo": urlOfUploadedImage,
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": userPhoneTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => const Drewer()));
  }

  chooseImageFromGallery() async {
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
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            const SizedBox(
              height: 5,
            ),
            imageFile == null
                ? Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          chooseImageFromGallery();
                        },
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
                          onTap: (){
                            chooseImageFromGallery();
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(25),
                            color:  Color.fromARGB(235, 1, 72, 130),
                            child: Container(
                             
                              height: 30,
                              width: 30,
                              child: const Icon(Icons.add_a_photo_rounded,
                              size: 20,
                                  color:Colors.white),
                            ),
                          ),
                        ),
                      )
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
                          image: FileImage(
                            File(
                              imageFile!.path,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),

            /* GestureDetector(
                        onTap: () {
                          chooseImageFromGallery();
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ),*/
            const Text("Add your photo"),
            const SizedBox(
              height: 20,
            ),

            //text fields + button
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextFormField(
                      controller: userNameTextEditingController,
                      decoration: const InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.person),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: "User Name",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextFormField(
                      controller: emailTextEditingController,
                      decoration: const InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.email),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: "User Email",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: userPhoneTextEditingController,
                      decoration: const InputDecoration(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.phone_android),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: "User Phone",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextFormField(
                      obscureText: passwordVisible,
                      controller: passwordTextEditingController,
                      decoration: InputDecoration(
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.lock),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: "password",
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  MaterialButtons(
                    borderRadius: BorderRadius.circular(10),
                    meterialColor: const Color.fromARGB(255, 3, 22, 60),
                    containerheight: 50,
                    elevationsize: 20,
                    textcolor: Colors.white,
                    fontSize: 18,
                    textweight: FontWeight.bold,
                    text: "Register",
                    onTap: () {
                      checkIfNetworkIsAvailable();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an Account?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                //textbutton
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                  child: const Text(
                    "Login Here",
                    style: TextStyle(color: Color.fromARGB(255, 1, 72, 130)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
