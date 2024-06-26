import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino library
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:new_app/Drivers/drivers_data.dart';
import 'package:new_app/components/my_painter.dart';

class SpalshRipple1 extends HookWidget {
  const SpalshRipple1({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers =
        List.generate(4, (i) => useAnimationController(duration: Duration(seconds: i < 3 ? 2 : 1)));

    final animations = List.generate(3, (i) => [
      useAnimation(Tween<double>(begin: 0, end: i == 2 ? 500 : 150)
          .animate(CurvedAnimation(parent: controllers[i], curve: Curves.ease))),
      useAnimation(Tween<double>(begin: 1, end: 0)
          .animate(CurvedAnimation(parent: controllers[i], curve: Curves.ease))),
      useAnimation(Tween<double>(begin: 10, end: 0)
          .animate(CurvedAnimation(parent: controllers[i], curve: Curves.ease))),
    ]);

    final centerCircleRadiusAnimation =
        useAnimation(Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(parent: controllers[3], curve: Curves.fastOutSlowIn)));

    useEffect(() {
      controllers[0].repeat();
      Timer(const Duration(milliseconds: 765), () => controllers[1].forward());
      Timer(const Duration(milliseconds: 1050), () => controllers[2].forward());
      controllers[3].repeat(reverse: true);
      return () => controllers.forEach((controller) => controller.dispose());
    }, []);

    final currentUser = FirebaseAuth.instance.currentUser;
    final userRef = currentUser != null ? FirebaseDatabase.instance.ref('users/${currentUser.uid}') : null;

    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>
        (
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 600,
              child: CupertinoActionSheet(
                title: Text('User Information'),
                message: currentUser == null || userRef == null
                    ? Text('No user logged in')
                    : StreamBuilder(
                        stream: userRef.onValue,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
                            final data = Map<String, dynamic>.from(snapshot.data.snapshot.value);
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    data['photo'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('User Name: ${data['username']}'),
                                Text('Email: ${data['email']}'),
                              ],
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Stack(
          children: [
            const DriverListScreen(),
            Center(
              child: CustomPaint(
                painter: MyPainter(
                  animations[0][0],
                  animations[0][1],
                  animations[0][2],
                  animations[1][0],
                  animations[1][1],
                  animations[1][2],
                  animations[2][0],
                  animations[2][1],
                  animations[2][2],
                  centerCircleRadiusAnimation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
