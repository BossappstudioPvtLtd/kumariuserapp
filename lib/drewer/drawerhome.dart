import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/auth/login_page.dart';
import 'package:new_app/components/info_card.dart';
import 'package:new_app/components/list_tiles.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/components/screen_bright.dart';
import 'package:new_app/components/text_add.dart';
import 'package:new_app/drewer/About/about.dart';
import 'package:new_app/drewer/Gift/gift_details.dart';
import 'package:new_app/drewer/HelpeCenter/help.dart';
import 'package:new_app/drewer/rider_history.dart';
import 'package:new_app/drewer/Settings/settings.dart';
import 'package:new_app/navigatinbar/botton_navigtion.dart';

class Drewer extends StatefulWidget {
  const Drewer({super.key});

  @override
  State<Drewer> createState() => _DrewerState();
}

class _DrewerState extends State<Drewer> {
  static double value = 0;

  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<void> _signOutGoogle() async {
  // await _firebaseAuth.signOut();
  // await _googleSignIn.signOut();
  // }

 

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
                          showCupertinoModalPopup(
                              context: context,
                              builder: (builder) {
                                return const ScreanBrightness();
                              });
                        },
                        icon: Icons.wb_sunny_outlined,
                        text: "Brightness".tr(),
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
                        text: "Rider History".tr(),
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
                        text: "Settings".tr(),
                      ),
                      ListTiles(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GiftPage(),
                            ),
                          );
                        },
                        icon: Icons.card_giftcard_rounded,
                        text: "Gift".tr(),
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
                        icon: Icons.headset_mic_outlined,
                        text: "Help Center".tr(),
                      ),
                      ListTiles(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const About(),
                            ),
                          );
                        },
                        icon: Icons.info_outline_rounded,
                        text: "About".tr(),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      ListTiles(
                        onTap: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  elevation: 20,
                                  title: Text('Sign Out Your Account'.tr()),
                                  content: TextEdt(
                                    text:
                                        'Do you want to continue with sign out?'
                                            .tr(),
                                    fontSize: null,
                                    color: null,
                                  ),
                                  actions: <Widget>[
                                    MaterialButtons(
                                      onTap: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      elevationsize: 20,
                                      text: 'Cancel'.tr(),
                                      fontSize: 17,
                                      containerheight: 40,
                                      containerwidth: 100,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      onPressed: null,
                                    ),
                                    MaterialButtons(
                                      onTap: () {
                                        FirebaseAuth.instance.signOut();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    const LoginScreen()));
                                      },
                                      elevationsize: 20,
                                      text: 'Continue'.tr(),
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
                        text: "Sign Out".tr(),
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

class Payment {
  const Payment();
}
