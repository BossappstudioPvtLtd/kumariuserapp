import 'package:flutter/material.dart';
import 'package:new_app/Service/auth_gate.dart';
import 'package:new_app/components/animation_button.dart';
import 'package:new_app/components/image_add.dart';
import 'package:new_app/components/text_animation.dart';

class OnBoding extends StatefulWidget {
  const OnBoding({super.key});

  @override
  State<OnBoding> createState() => _OnBodingState();
}

class _OnBodingState extends State<OnBoding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 193, 7),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [
            const Center(
                child: ImageAdd(
              image: "assets/logo/logo.png",
              height: 400,
            )),
            const SizedBox(
              height: 20,
            ),
            const TextAnimation(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: AnimationButton(
                onTap: () => Navigator.push(
                  context,
                  ScaleTransition1(
                    const Authgate(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScaleTransition1 extends PageRouteBuilder {
  final Widget page;

  ScaleTransition1(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn);
            return ScaleTransition(
              alignment: Alignment.bottomCenter,
              scale: animation,
              child: child,
            );
          },
        );
}
