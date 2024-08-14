import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class SliderButton1 extends StatefulWidget {
  const SliderButton1({super.key});

  @override
  SliderButton1State createState() {
    var sliderButton1State = SliderButton1State();
    return sliderButton1State;
  }
}

class SliderButton1State extends State<SliderButton1> {
  @override
  Widget build(BuildContext context) {
    return SliderButton(
      action: () async {
            // Simulate some asynchronous action (e.g., network request or delay)
            await Future.delayed(const Duration(seconds: 1)); // Simulating a delay of 1 second

            // Return true if the action is considered successful, false otherwise
            return true;
          },
      label: const Text(
        'Slide to cancel Event',
        style: TextStyle(
            color: Color(0xff4a4a4a),
            fontWeight: FontWeight.w500,
            fontSize: 17),
      ),
      icon: const Text(
        'Go',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 40,
        ),
      ),
      buttonColor: Colors.black,
    );
  }
}
