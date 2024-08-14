import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:new_app/navigatinbar/image_animation.dart';
import 'package:new_app/navigatinbar/trips_history_page.dart';
import 'package:new_app/navigatinbar/favorite_page.dart';
import 'package:new_app/navigatinbar/profile_page.dart';
import 'package:new_app/new_test.dart';

class BottonNavigations extends StatefulWidget {
  const BottonNavigations({super.key});

  @override
  State<BottonNavigations> createState() => _BottonNavigationsState();
}

CommonMethods cMethods = CommonMethods();



class _BottonNavigationsState extends State<BottonNavigations> {
  List<IconData> iconList = [
    Icons.home_outlined,
    Icons.account_tree,
    Icons.favorite_outline_sharp,
    Icons.person_2_outlined
  ];
  List bottomPages = [
    const HomePage1(),
    const TripsHistoryPage(),
    PageListGuideAr(),
    const ProfilePage()
  ];

  int bottomNavInde = 0;  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 22, 60),
        child: const Icon(
          Icons.location_on_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        iconSize: 30,
        inactiveColor: Colors.white,
        icons: iconList,
        activeColor: Colors.grey.shade50,
        activeIndex: bottomNavInde,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) => setState(() => bottomNavInde = index),
        backgroundColor: const Color.fromARGB(255, 3, 22, 60),
      ),
      body: bottomPages[bottomNavInde],
    );
  }
}
