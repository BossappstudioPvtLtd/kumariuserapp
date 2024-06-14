import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/phone_otp.dart/numeric_pad.dart';
import '../drewer/drawerhome.dart';
import '../phone_otp.dart/done.dart';




class New extends StatefulWidget {
    const New({super.key});

    @override
    State<New> createState() => _HomeState();
}

class _HomeState extends State<New>
{
    final TextEditingController _codecontroller = TextEditingController();
    String phoneNumber = "", data = "";
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String smscode = "";

    _signInWithMobileNumber() async {
    try {
        await _auth.verifyPhoneNumber(
            phoneNumber: '+91${data.trim()}',
            verificationCompleted: (PhoneAuthCredential authCredential) async {
            await _auth.signInWithCredential(authCredential).then((value) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const Drewer()));
            });
            },
            verificationFailed: ((error)
            {
            debugPrint(error as String?);
            }),
            codeSent: (String verificationId, [int? forceResendingToken]) {
            showCupertinoDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  surfaceTintColor:Colors.white,
                  
                    title: const Text("Enter OTP"),
                    content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        TextField(
                        controller: _codecontroller,
                        )
                    ],
                    ),
                    actions: [
                    ElevatedButton(
                        onPressed: () {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            smscode = _codecontroller.text;
                            PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: smscode);
                            auth.signInWithCredential(credential)
                                .then((result) {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Done()));
                                                      }).catchError((e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('Error Occured'),
                                    content: const Text('Please check and enter the correct verification code'), // Format total price with two decimal places
                                    actions: [
                                    TextButton(
                                        onPressed: () {
                                        Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                    ),
                                    ],
                                );
                                },
                            );
                            // print(e);
                            });
                        },
                        child: const Text("Done"))
                    ],
                ));
            },
            codeAutoRetrievalTimeout: (String verificationId) {
            verificationId = verificationId;
            },
            timeout: const Duration(seconds: 45));
    } catch (e) {
        debugPrint(e as String?);
    }
    }

    @override
    Widget build(BuildContext context) {
    return
        Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        title: const Text(
            "Continue with phone",
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        ),
        body: SafeArea(
        child: Column(
            children: [
            Expanded(
                child: Container(
                  height: 400,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                    ],
                    ),
                ),
                child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   
                      Image.asset("assets/vectors/otpimg.png",height: 200,width: 400,),
                    
                     const Text(
                        "You'll receive a 6 digit code to verify next.",
                        style: TextStyle(
                            fontSize: 13,
                           color: Colors.black,
                        ),
                        ),
                    
                    ],
                ),
                ),
            ),
            
            Material(
              elevation: 20,
              
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(25),
                  ),
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                      children: [
                      SizedBox(
                          width: 230,
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const Text(
                              "Enter your phone",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                              ),
                              ),
                              const SizedBox(
                              height: 8,
                              ),
                              Text(
                              phoneNumber,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                              ),
                              ),
                          ],
                          ),
                      ),
                      Expanded(
                          child: GestureDetector(
                          onTap: () {
                              data = phoneNumber;
                              phoneNumber = "";
              
                              setState(() {
              
                              });
              
                              _signInWithMobileNumber();
                          },
                          child: Material(
                            elevation: 15,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 40,
                                decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 211, 206, 206),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                ),
                                ),
                                child: const Center(
                                child: Text(
                                    "Continue",
                                    style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                                ),
                            ),
                          ),
                          ),
                      ),
                      ],
                  ),
                  ),
              ),
            ),
            NumericPad(
                onNumberSelected: (value) {
                setState(() {
                    if (value != -1) {
                    phoneNumber = phoneNumber + value.toString();
                    }
                    else
                    {
                    phoneNumber =
                        phoneNumber.substring(0, phoneNumber.length - 1);
                    }
                });
                },
            ),
            ],
        ),
        ),
    );
    }
}