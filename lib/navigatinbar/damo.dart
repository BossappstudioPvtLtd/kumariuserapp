 import 'package:flutter/material.dart';

class BS extends StatefulWidget {
  const BS({super.key});

      @override
        // ignore: library_private_types_in_public_api
        _BS createState() => _BS();
    }

    class _BS extends State<BS> {
      bool _showSecond = false;

      @override
      Widget build(BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) => AnimatedContainer(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            duration: const Duration(milliseconds: 400),
            child: AnimatedCrossFade(
                firstChild: Container(
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height - 200),
//remove constraint and add your widget hierarchy as a child for first view
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      onPressed: () => setState(() => _showSecond = true),
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Suivant"),
                        ],
                      ),
                    ),
                  ),
                ),
                secondChild: Container(
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height / 3),
//remove constraint and add your widget hierarchy as a child for second view
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      onPressed: () => setState(() => _showSecond = false),
                      color: Colors.green,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("ok"),
                        ],
                      ),
                    ),
                  ),
                ),
                crossFadeState: _showSecond
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 400)),
          ),
        );
      }
    }