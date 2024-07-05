// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:new_app/Const/global_var.dart';
import 'package:new_app/auth/forgot_password.dart';
import 'package:new_app/auth/registering.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/components/applogo_area.dart';
import 'package:new_app/components/loading_dialog.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/drewer/drawerhome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();

    passwordVisible = true;
  }

   checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation()
  {

    if(!emailTextEditingController.text.contains("@"))
    {
      cMethods.displaySnackBar("please write valid email.", context);
    }
    else if(passwordTextEditingController.text.trim().length < 5)
    {
      cMethods.displaySnackBar("your password must be atleast 6 or more characters.", context);
    }
    else
    {
      signInUser();
    }
  }

  signInUser() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Allowing you to Login..."),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    if(userFirebase != null)
    {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
      usersRef.once().then((snap)
      {
        if(snap.snapshot.value != null)
        {
          if((snap.snapshot.value as Map)["blockStatus"] == "no")
          {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const Drewer()));
          }
          else
          {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("you are blocked. Contact admin: Kumariacabs@gmail.com", context);
          }
        }
        else
        {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("your record do not exists as a User.", context);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ApplogoArea(
              text: "JOIN WITH US",
            ),
            const SizedBox(
              height: 30,
            ),

            const Text(
              "Login as a Users",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const ForgotPassword()));
                    },
                    child: const Text(
                      'Forgot password',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MaterialButtons(
                    borderRadius: BorderRadius.circular(10),
                    meterialColor: const Color.fromARGB(255, 3, 22, 60),
                    containerheight: 50,
                    elevationsize: 20,
                    textcolor: Colors.white,
                    fontSize: 18,
                    textweight: FontWeight.bold,
                    text: "Login",
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
                  "Don't have an Account?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                //textbutton
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const SignUpScreen()));
                  },
                  child: const Text(
                    "Register Here",
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
