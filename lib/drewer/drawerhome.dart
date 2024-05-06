// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/components/info_card.dart';
import 'package:new_app/components/list_tiles.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/components/text_add.dart';
import 'package:new_app/drewer/electric_car.dart';
import 'package:new_app/drewer/help.dart';
import 'package:new_app/drewer/notifications.dart';
import 'package:new_app/drewer/rider_history.dart';
import 'package:new_app/drewer/settings.dart';
import 'package:new_app/navigatinbar/botton_navigtion.dart';

class Drewer extends StatefulWidget {
  const Drewer({super.key});

  @override
  State<Drewer> createState() => _DrewerState();
}

class _DrewerState extends State<Drewer> {
  static double value = 0;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signOutGoogle() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  bool _isLoading = false;

  void _navigateToSecondScreen() async {
    setState(() {
      _isLoading = true;

      // User chose to sign out
      _signOutGoogle();
      Navigator.of(context).pop(true);
      Navigator.pop(context);
    });

    // Simulate a network request or some delay
    await Future.delayed(const Duration(seconds: 0));

    setState(() {
      _isLoading = false;
    });

    // Navigate to second screen
    Navigator.of(context).pop(true);
    // User chose to sign out
    _signOutGoogle();

    Navigator.push(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 13, 33, 49),
              Color.fromARGB(255, 7, 43, 84),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        height: double.infinity,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const InfoCard(
                    name: '',
                    Profession: '',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      ListTiles(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ElectricCars(),
                            ),
                          );
                        },
                        icon: Icons.directions_car_outlined,
                        text: "Elactric cars",
                      ),
                      ListTiles(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RiderHistory(),
                            ),
                          );
                        },
                        icon: Icons.settings_backup_restore_rounded,
                        text: "Rider history",
                      ),
                      ListTiles(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Notifications(),
                            ),
                          );
                        },
                        icon: Icons.notification_add_outlined,
                        text: "Notifications",
                      ),
                      ListTiles(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Settings(),
                            ),
                          );
                        },
                        icon: Icons.settings_outlined,
                        text: "Settings",
                      ),
                      ListTiles(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Help(),
                            ),
                          );
                        },
                        icon: Icons.help_center_outlined,
                        text: "Help",
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      ListTiles(
                        onTap: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(255, 236, 255, 255),
                                  elevation: 20,
                                  title: const Text('Google Sign Out'),
                                  content: const TextEdt(
                                    text:
                                        'Do you want to continue with sign out?',
                                    fontSize: null,
                                    color: null,
                                  ),
                                  actions: <Widget>[
                                    MaterialButtons(
                                      onTap: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      elevationsize: 20,
                                      text: '   Cancel    ',
                                      fontSize: 17,
                                      containerheight: 40,
                                      containerwidth: 100,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      onPressed: null,
                                    ),
                                    MaterialButtons(
                                      onTap: () {
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: _isLoading
                                                    ? LoadingAnimationWidget
                                                        .threeArchedCircle(
                                                        color: Colors.blue,
                                                        size: 50,
                                                      )
                                                    : ElevatedButton(
                                                        onPressed:
                                                            _navigateToSecondScreen,
                                                        child: const Text(
                                                            'Are you sure'),
                                                      ),
                                              );
                                            });
                                      },
                                      elevationsize: 20,
                                      text: 'Continue',
                                      fontSize: 17,
                                      containerheight: 40,
                                      containerwidth: 100,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      onPressed: null,
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icons.logout_outlined,
                        text: "Sign Out",
                      ),
                    ],
                  ),
                ],
              ),
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: value),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn,
                  builder: (_, double val, __) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..setEntry(0, 3, 200 * val)
                        ..rotateY((pi / 6) * val),
                      child: const BottonNavigations(),
                    );
                  }),
              GestureDetector(
                onHorizontalDragUpdate: (e) {
                  if (e.delta.dx > 0) {
                    setState(() {
                      value = 1;
                    });
                  } else {
                    setState(() {
                      value = 0;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
