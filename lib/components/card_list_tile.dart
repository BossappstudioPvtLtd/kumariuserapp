import 'package:flutter/material.dart';

class CardListTILe extends StatefulWidget {
  final void Function()? onTap;
  final String title;
  const CardListTILe({super.key, this.onTap, required this.title});

  @override
  State<CardListTILe> createState() => _CardListTILeState();
}

class _CardListTILeState extends State<CardListTILe> {
  @override
  Widget build(BuildContext context) {
    return   Card(
       color:Theme.of(context).colorScheme.background,
            child: ListTile(
              onTap:widget.onTap
              ,
              title:  Text(widget.title,
              ),
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
            ),
          );
  }
}