// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/navigatinbar/home_page.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  _DriverListScreenState createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  final DatabaseReference _driversRef =
      FirebaseDatabase.instance.ref().child('drivers');
  List<Driver> _drivers = [];

  @override
  void initState() {
    super.initState();
    _driversRef.onValue.listen((DatabaseEvent event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Driver> loadedDrivers = [];
      data.forEach((key, value) {
        loadedDrivers.add(Driver.fromMap(Map<String, dynamic>.from(value)));
      });
      setState(() {
        _drivers = loadedDrivers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _drivers.length,
      itemBuilder: (context, index) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: MessageClipper(borderRadius: 1),
                      child: Container(
                        height: 75,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                              image: NetworkImage(
                                _drivers[index].photo,
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Material(
                        elevation: 8,
                        shadowColor: const Color(0xff653ff4),
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: NetworkImage(
                                  _drivers[index].photo,
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return Scaffold(
                                backgroundColor: Colors.white10,
                                body: Column(
                                  children: [
                                    const SizedBox(
                                      height: 200,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Container(
                                        height: 230,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(32)),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    height: 130,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  32)),
                                                    ),
                                                    child: Image.asset(
                                                      "assets/images/user.jpg",
                                                      // height: 130,
                                                      fit: BoxFit.cover,
                                                    )),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                const Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Mohammed shahin',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text('Cinemas',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 14)),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text('Thus ',
                                                        style: TextStyle(
                                                            fontSize: 14))
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25),
                                              child: MaterialButtons(
                                                text: 'Enjoy Your Ride!'.tr(),
                                                textcolor: Colors.white,
                                                meterialColor:
                                                    const Color.fromARGB(
                                                        255, 3, 22, 60),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              const HomePage()));
                                                },
                                                elevationsize: 20,
                                                containerheight: 40,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
              const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                      ),
                      Text(
                        "950 m ",
                        style: TextStyle(
                          color: Color(0xff653ff4),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Text(
                _drivers[index].name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold),
              ),
              /*Text('Phone: ${_drivers[index].phone}\n'
                'Model: ${_drivers[index].carModel}\n'
                'Number: ${_drivers[index].carNumber}\n'
                'Seats: ${_drivers[index].carSeats}'),*/
              const SizedBox(
                height: 300,
              )
            ]);
      },
    );
  }
}

class Driver {
  final String photo;
  final String name;
  final String phone;
  final String carModel;
  final String carNumber;
  final int carSeats;

  Driver({
    required this.photo,
    required this.name,
    required this.phone,
    required this.carModel,
    required this.carNumber,
    required this.carSeats,
  });

  factory Driver.fromMap(Map<String, dynamic> data) {
    return Driver(
      photo: data['photo'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      carModel: data["car_details"]["carModel"] ?? '',
      carNumber: data["car_details"]['carNumber'] ?? '',
      carSeats: data["car_details"]['carSeats'] ?? 0,
    );
  }
}
