import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SpeakButton extends StatelessWidget {
  const SpeakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.record_voice_over_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Speak".tr(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                )
              ]
    );
    
  }
}