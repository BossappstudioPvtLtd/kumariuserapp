import 'package:flutter/material.dart';

class ImageAdd extends StatefulWidget {
  final void Function()? onTap;
  final String image;
  final double? height;
  final double? width;
  const ImageAdd(
      {super.key,
      this.onTap,
      required this.image,
      this.height,
      this.width});

  @override
  State<ImageAdd> createState() => _ImageAddState();
}

class _ImageAddState extends State<ImageAdd> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Image.asset(widget.image),
      ),
    );
  }
}
