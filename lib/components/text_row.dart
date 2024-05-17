import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TextRow extends StatefulWidget {
 
 final String data;
  const TextRow({super.key,  required this.data});

  @override
  State<TextRow> createState() => _TextRowState();
}

class _TextRowState extends State<TextRow> {
  @override
  Widget build(BuildContext context) {
    return   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("*"),
                    
                    SizedBox(
                      width: 300,
                      child:Text(widget.data,style: const TextStyle(fontSize: 12 ),),)
                  ],
                  
                );
  }
}