// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/components/applogo_area.dart';
import 'package:new_app/components/m_buttons.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailTextEditingController = TextEditingController();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    super.dispose();
  }

  Future PasswordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailTextEditingController.text.trim());
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return  AlertDialog(
              elevation: 20,
              backgroundColor: Colors.white,
              content: const SizedBox(
                  height: 100,
                  width: 200,
                  child: Center(
                      child: Text(
                    ("Password rest link sent! Check your email"),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ))),
                   actions:  [
                MaterialButtons(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  elevationsize: 20,
                  text: 'Ok',
                  fontSize: 20,
                  textweight: FontWeight.bold,
                  textcolor: Colors.white,
                  meterialColor: const Color.fromARGB(255, 3, 22, 60),
                  containerheight: 30,
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));},
                )
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 20,
              backgroundColor: Colors.white,
              content: SizedBox(
                height: 100,
                width: 200,
                child: Center(
                  child: Text(
                    e.message.toString(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              actions:  [
                MaterialButtons(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  elevationsize: 20,
                  text: 'Ok',
                  fontSize: 20,
                  textweight: FontWeight.bold,
                  textcolor: Colors.white,
                  meterialColor: const Color.fromARGB(255, 3, 22, 60),
                  containerheight: 30,
                  onTap: (){Navigator.of(context).pop(false);},
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ApplogoArea(text: "Forgot Password"),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const Text(
                    'Enter The Your Email And We will send You A Password Reaset Link',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
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
                        labelText: "Email",
                        // hintText: '$userEmail',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MaterialButtons(
                    borderRadius: BorderRadius.circular(10),
                    meterialColor: const Color.fromARGB(255, 3, 22, 60),
                    containerheight: 50,
                    elevationsize: 20,
                    textcolor: Colors.white,
                    fontSize: 18,
                    textweight: FontWeight.bold,
                    text: "Forgot Password",
                    onTap: PasswordReset,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
