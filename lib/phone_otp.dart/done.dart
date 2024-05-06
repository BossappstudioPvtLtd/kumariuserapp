import 'package:flutter/material.dart';

class Done extends StatefulWidget {
    const Done({super.key});

    @override
    State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
    @override
    Widget build(BuildContext context) {
    return
        Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
        automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
        elevation: 0,),
        body: Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(

            children: [

              Image.asset('images/verify.webp',
              height: 300,),
               const SizedBox(
                height: 40,
                ),
               const Text('Phone Number Verified',
                style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 14, 3, 64)
                ),)
            ],
            ),
        ),
        ),
    );
    }
}