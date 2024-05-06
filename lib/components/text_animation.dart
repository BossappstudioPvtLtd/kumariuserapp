// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';

class TextAnimation extends StatefulWidget {
  const TextAnimation({super.key});

  @override
  _TextAnimationState createState() => _TextAnimationState();
}

class _TextAnimationState extends State<TextAnimation> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SlideFadeTransition(
          curve: Curves.elasticOut,
          delayStart: Duration(milliseconds: 500),
          animationDuration: Duration(milliseconds: 1200),
          offset: 2.5,
          direction: Direction.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Safe Ride With Us!",
              style: TextStyle(
                  color: Color.fromARGB(255, 15, 6, 77),
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SlideFadeTransition(
          curve: Curves.elasticOut,
          delayStart: Duration(milliseconds: 1000),
          animationDuration: Duration(milliseconds: 1200),
          offset: 2.5,
          direction: Direction.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Text(
              "Discover the freedom of   travel with Kumari Cabs! ",
              style: TextStyle(
                  color: Color.fromARGB(255, 15, 6, 77),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SlideFadeTransition(
          delayStart: Duration(milliseconds: 1000),
          animationDuration: Duration(milliseconds: 700),
          child: Text(
            '',
            style: TextStyle(fontSize: 20),
          ),
        ),
        SlideFadeTransition(
          curve: Curves.elasticOut,
          delayStart: Duration(milliseconds: 1800),
          animationDuration: Duration(milliseconds: 1200),
          offset: -2.5,
          direction: Direction.vertical,
          child: Text('', style: TextStyle(color: Colors.white)),
        ),
        SlideFadeTransition(
          delayStart: Duration(milliseconds: 2300),
          animationDuration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          offset: 5,
          child: Text(
            "",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}

enum Direction { vertical, horizontal }

class SlideFadeTransition extends StatefulWidget {
  final Widget child;

  final double offset;

  final Curve curve;

  final Direction direction;

  final Duration delayStart;

  final Duration animationDuration;

  const SlideFadeTransition({
    super.key,
    required this.child,
    this.offset = 1.0,
    this.curve = Curves.easeIn,
    this.direction = Direction.vertical,
    this.delayStart = const Duration(seconds: 0),
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  _SlideFadeTransitionState createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animationSlide;

  late AnimationController _animationController;

  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    if (widget.direction == Direction.vertical) {
      _animationSlide = Tween<Offset>(
              begin: Offset(0, widget.offset), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    } else {
      _animationSlide = Tween<Offset>(
              begin: Offset(widget.offset, 0), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    }

    _animationFade =
        Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      curve: widget.curve,
      parent: _animationController,
    ));

    Timer(widget.delayStart, () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: _animationSlide,
        child: widget.child,
      ),
    );
  }
}
