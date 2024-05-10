import 'package:flutter/material.dart';

class SettingListTile extends StatefulWidget {
  final void Function()? onTap;
  final void Function()? onTap1;

  final IconData? leadingicon;
  final IconData? leadingicon1;

  final Color? leadingiconcolor;
  final Color? leadingiconcolor1;

  final String text;
  final String text1;

  final IconData? trailingicon;
  final IconData? trailingicon1;

  const SettingListTile(
      {super.key,
      this.onTap,
      required this.text,
      this.leadingiconcolor,
      this.leadingicon,
      this.trailingicon,
      this.onTap1,
      this.leadingicon1,
      required this.text1,
      this.leadingiconcolor1,
      this.trailingicon1});

  @override
  State<SettingListTile> createState() => _SettingListTileState();
}

class _SettingListTileState extends State<SettingListTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: 
        const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: widget.onTap,
              child: ListTile(
                leading:
                    Icon(widget.leadingicon, color: widget.leadingiconcolor),
                title: Text(
                  widget.text,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  widget.trailingicon,
                  size: 20,
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onTap1,
              child: ListTile(
                leading: Icon(
                  widget.leadingicon1,
                  color: widget.leadingiconcolor1,
                ),
                title: Text(
                  widget.text1,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  widget.trailingicon,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
