import 'package:flutter/material.dart';

class ListTiles extends StatefulWidget {
  final IconData? icon;
  final void Function()? onTap;
  final String text;

  const ListTiles({super.key, this.icon, this.onTap, required this.text});

  @override
  State<ListTiles> createState() => _HomeState();
}

class _HomeState extends State<ListTiles> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.white,
      onTap: widget.onTap,
      leading: Icon(
        widget.icon,
        color: Colors.white70,
      ),
      title: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
