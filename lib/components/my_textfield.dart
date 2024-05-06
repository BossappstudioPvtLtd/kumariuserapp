import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String? hintText;
  final IconData? icon;
  final Color? color;
  final TextEditingController? controller;
  const MyTextField({
    super.key,
    this.hintText,
    this.icon,
    this.color, 
    this.controller,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Padding(
          
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Material(
            
            child: TextField(
              controller:widget.controller ,
              onChanged: (String value) {},
              cursorColor: const Color.fromARGB(255, 0, 0, 0),
              decoration: InputDecoration(
                hintText: widget.hintText,
                
                prefixIcon: Material(
                  elevation: 0,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 13,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
