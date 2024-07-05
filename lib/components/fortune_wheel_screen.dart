import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:new_app/components/scratchc_card.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  WheelScreenState createState() => WheelScreenState();
}

class WheelScreenState extends State<WheelScreen> {
  StreamController<int> selected = StreamController<int>();
  final List<FortuneItem> items = [
    FortuneItem(
        child: Image.asset(
          "assets/images/gift10.png",
          height: 50,
          width: 50,
        ),
        style: const FortuneItemStyle(
          color:Color.fromARGB(255, 26, 11, 28),
        )),
    FortuneItem(
        child: Image.asset("assets/images/gift9.png", height: 35, width: 35),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 86, 4, 100))),
    FortuneItem(
        child: Image.asset("assets/images/gift8.png", height: 19, width: 19),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 54, 2, 62))),
    FortuneItem(
        child: Image.asset(
          "assets/images/gift10.png",
          height: 50,
          width: 50,
        ),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 26, 11, 28))),
    FortuneItem(
        child: Image.asset("assets/images/gift9.png", height: 35, width: 35),
        style: const FortuneItemStyle(
          color:  Color.fromARGB(255, 86, 4, 100),
        )),
    FortuneItem(
        child: Image.asset("assets/images/gift8.png", height: 19, width: 19),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 54, 2, 62))),
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 88,
          child: SizedBox(
            height: 170,
            width: 170,
            child: Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                items: items,
                onAnimationEnd: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ScratchCard(),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          child: const Text('Spin'),
          onPressed: () {
            setState(() {
              selected.add(Fortune.randomInt(0, items.length));
            });
          },
        ),
      ],
    );
  }
}
