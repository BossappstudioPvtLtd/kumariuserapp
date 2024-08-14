// ignore_for_file: unused_field

import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:new_app/Service/google_auth.dart';
import 'package:new_app/Service/phone_authentication.dart';
import 'package:new_app/auth/otp_screen.dart';
//import 'package:new_app/auth/phonenumber.dart';
import 'package:new_app/components/applogo_area.dart';
import 'package:new_app/components/image_add.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _codecontroller = TextEditingController();
  
  final phoneController = TextEditingController();
  String phoneNumber = "", data = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String smscode = "";
  


  final PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> storeUserData(User user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}');

    await ref.set({
      'name': user.displayName,
      'email': user.email,
      "id": user.uid,
      "blockStatus": "no",
      'phone': phoneNumber,
      // Add other user details you want to store
    });
  }
 Country selectedCountry = Country(
    phoneCode: '91',
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'india',
    example: 'india',
    displayName: 'IN',
    displayNameNoCountryCode: 'IN',
    e164Key: "",
  );

  //send OTP

  sendOTP() async {
    await PhoneAuthentication().sendOTPCode(
      phoneController.text,
      (String verId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(verification: verId),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              const ApplogoArea(
                text: "JOIN WITH US",
              ),
              const SizedBox(
                height: 30,
              ),
               Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: phoneController,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter phone number';
                          }
                          if (value.length != 10) {
                            return 'Enter 10 digit number';
                          }
                    
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            phoneController.text = value;
                          });
                        },
                        autofillHints: const [AutofillHints.oneTimeCode],
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme: const CountryListThemeData(
                                      flagSize: 20,
                                      bottomSheetHeight: 400,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                    '${selectedCountry.flagEmoji}+ ${selectedCountry.phoneCode}'),
                              ),
                            ),
                          ),
                          suffixIcon: phoneController.text.length > 9
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Icon(Icons.done,
                                        color: Color.fromARGB(255, 53, 255, 60)),
                                  ),
                                )
                              : null,
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Material(
                        elevation: 20,
                        color: Colors.grey.shade300,
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              sendOTP();
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 14, 3, 64),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: ImageAdd(
                                    image: "assets/logo/phone.png",
                                    width: 40,
                                    height: 50,
                                  )),
                                  Text(
                                    "Continue with Phone",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
             
            // const PhoneScreen(),
              
              const SizedBox(
                height: 20,
              ),
             Text(
                "or",
                style: TextStyle(color: Colors.grey[00], fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                    elevation: 20,
                    color: Colors.grey.shade300,
                    child: GestureDetector(
                      onTap: () async {
                      
          
                        AuthMathods().signInWithGoogle(context);
                       
                      },
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 227, 171, 5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: ImageAdd(
                                image: "assets/logo/google.png",
                                width: 30,
                                height: 30,
                              )),
                              Text(
                                "Continue with google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
