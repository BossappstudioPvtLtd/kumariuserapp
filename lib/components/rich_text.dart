import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Rich extends StatefulWidget {
  final String? text;
  final String? text1;
  const Rich({super.key, this.text, this.text1});

  @override
  State<Rich> createState() => _RichState();
}

class _RichState extends State<Rich> {
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.only(left:15,bottom: 5),
      child: RichText(
                      text: TextSpan(
                        text:widget.text?.tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 12),
                        children:  <TextSpan>[
                          TextSpan(
                              text: widget.text1?.tr(),
                              style: const TextStyle( fontSize: 12,color: Colors.black54),),
                        ],
                      ),
                    ),
    );
  }
}