import 'package:flutter/material.dart';

class TextEdt extends StatefulWidget {
  final void Function()? onTap;
  final String text;
  final Color? color;
  final double? fontSize;
  final TextDecoration? decoration;
  const TextEdt({
    super.key,
    this.onTap,
    required this.text,
    this.color,
     this.fontSize, 
     this.decoration,
  });

  @override
  State<TextEdt> createState() => _TextEdtState();
}

class _TextEdtState extends State<TextEdt> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Text(
        widget.text,
        style: TextStyle(
            color: widget.color,
            fontWeight: FontWeight.w400,
            fontSize: widget.fontSize,
            decoration: widget.decoration),
      ),
    );
  }
}
