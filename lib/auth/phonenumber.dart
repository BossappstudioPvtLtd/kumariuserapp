// ignore_for_file: unrelated_type_equality_checks

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/auth/otp_screen.dart';

import '../Service/phone_authentication.dart';
import '../components/image_add.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    return
     SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter Your Phone Number',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
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
                ],
              ),
            
    );
  }
}
