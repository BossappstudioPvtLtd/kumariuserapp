// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NewTextField extends StatefulWidget {
  final Color? materialcolor;
  final Color? fillColor;
  final String? labelText;
  final TextStyle? labelStylecolor;
  final TextStyle? textstylecolor;
  final TextEditingController? controller;
  final IconData? icon;
  final Color? iconcolor;
  final TextInputType? keyboardType;
  final bool obscureText ;
  final Widget? suffixIcon;
  const NewTextField({
    super.key,
    this.materialcolor,
    this.fillColor,
    this.labelText,
    this.labelStylecolor,
    this.textstylecolor,
    this.controller,
    this.icon,
    this.iconcolor, 
    this.keyboardType,  required this.obscureText, 
    this.suffixIcon,
  });

  @override
  State<NewTextField> createState() => NewTextFieldState();
}

class NewTextFieldState extends State<NewTextField> {

   

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 10,
        color: widget.materialcolor,
        borderRadius: BorderRadius.circular(10.0),
        child: TextField(
           obscureText: widget.obscureText, 
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          style: widget.textstylecolor,
          decoration: InputDecoration(
              
              filled: true,
              fillColor: widget.fillColor,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelText: widget.labelText,
              labelStyle: widget.labelStylecolor,
              suffixIcon: widget.suffixIcon,
              
              icon: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(widget.icon, color: widget.iconcolor),
              )),
        ),
      ),
    );
  }
}
