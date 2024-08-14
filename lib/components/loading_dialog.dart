// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


class LoadingDialog extends StatelessWidget
{
  String messageText;

  LoadingDialog({super.key, required this.messageText,});



  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black87,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(5),
        ),
       
          child: Row(
            children: [

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),

              const SizedBox(width: 5,),

              Text(
                messageText,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),

            ],
          ),
        ),
      
    );
  }
}
