import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app/new/widget/locations_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      
       // appBar: buildAppBar(),
        body: Container(
           decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Color.fromARGB(255, 3, 6, 56),
              ],
            )
          ),
          child: const LocationsWidget()),
       
      );

  

 
}
