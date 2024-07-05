
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/drewer/drawerhome.dart';
class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshort) {
          if (snapshort.hasData) {
            return  const Drewer();
          } else {
            return const LoginScreen ();
          }
        },
      ),
    );
  }
}
