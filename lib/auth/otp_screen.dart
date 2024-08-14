// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:new_app/Service/phone_authentication.dart';
import 'package:new_app/auth/phone_user_profile.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final String verification;
  const OTPScreen({
    super.key,
    required this.verification,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  _commonPinput([Color color = Colors.black]) => PinTheme(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color),
        ),
      );

//verifyOTP

  verifyOTP() async {
    try {
      String result = await PhoneAuthentication().verifyOTPCode(
        verifyId: widget.verification,
        otp: otpController.text,
      );
      if (result == 'success') {
       Navigator.push(context, MaterialPageRoute(builder: (_)=>const PhoneUserProfile()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verification Failed'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/phoneScreen');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/vectors/otp.png',
                  height: 250,
                  width: 250,
                ),
              ),
              const Text(
                'OTP Verification',
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Enter the OTP Code sent to your number',
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize:  12),
              ),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: _commonPinput(),
                focusedPinTheme: _commonPinput(Colors.black),
                followingPinTheme: _commonPinput(Colors.black),
                onChanged: (value) {
                  otpController.text = value;
                },
              ),
              const SizedBox(height: 100),
              
               Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Material(
                        elevation: 20,
                        color: Colors.grey.shade300,
                        child: GestureDetector(
                          onTap: verifyOTP,
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
                                  
                                  Text(
                                    "Continue",
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
