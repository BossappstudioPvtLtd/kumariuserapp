import 'package:flutter/material.dart';
//import 'package:new_app/auth/login.dart';

class AnimationButton extends StatelessWidget {
  final void Function()? onTap;
  const AnimationButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 15, 6, 77),
      elevation: 10,
      borderRadius: const BorderRadius.all(
        Radius.circular(30),
      ),
      child: InkWell(
        onTap:onTap,
        child: const SizedBox(
          height: 50,
          width: 200,
          child: Center(
            child: Text(
              "Let's get started!",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
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
