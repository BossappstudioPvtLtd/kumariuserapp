import 'package:flutter/material.dart';


class MyButton extends StatefulWidget {
  final String text;
  final  void Function()? onPressed;


  const MyButton({
    super.key,
    required this.text, required this.onPressed,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromARGB(255, 3, 22, 60),),
        child: TextButton(
          onPressed:widget.onPressed,
          child: Text(
            widget.text,
            style:  const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
