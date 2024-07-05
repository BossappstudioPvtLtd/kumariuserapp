import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app/components/clipper.dart';

class ApplogoArea extends StatefulWidget {
  final String text;
  const ApplogoArea({super.key, required this.text});

  @override
  State<ApplogoArea> createState() => _ApplogoAreaState();
}

class _ApplogoAreaState extends State<ApplogoArea> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper2(),
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(192, 104, 104, 104),
              Color.fromARGB(19, 190, 185, 185)
            ])),
            child: const Column(),
          ),
        ),
        ClipPath(
          clipper: WaveClipper3(),
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 255, 193, 7),
              Color.fromARGB(255, 255, 193, 7),
              Color.fromARGB(255, 230, 141, 25)
            ])),
            child: const Column(),
          ),
        ),
        ClipPath(
          clipper: WaveClipper1(),
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 4, 6, 33),
              Color.fromARGB(223, 33, 39, 75)
            ])),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 214, 212, 212),
                    fontSize: 25,
                  ),
                ),
              

                
              ],
            ),
          ),
        ),
      ],
    );
  }
}
