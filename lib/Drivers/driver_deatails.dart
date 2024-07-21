import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_app/components/m_buttons.dart';

class Deatails extends StatefulWidget {
  const Deatails({super.key});

  @override
  State<Deatails> createState() => _DeatailsState();
}

class _DeatailsState extends State<Deatails> {
  @override
  Widget build(BuildContext context) {
    return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Material(
              borderRadius: BorderRadius.circular(30),
              elevation: 20,
              child: Container(
               height: 300,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    color: Color.fromARGB(255, 236, 232, 232)),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                      Container(
                        height: 130,
                        decoration: const BoxDecoration(  borderRadius: BorderRadius.all(Radius.circular(32)),),
                        child: Image.asset(
                            "assets/images/user.jpg",
                           // height: 130,
                            fit: BoxFit.cover,
                          
                          ),
                      ),
                        const SizedBox(
                          width: 16,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mohammed shahin',
                                style: TextStyle(color: Colors.black,
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 8,
                              
                            ),
                            Text('Cinemas',
                                style: TextStyle(color: Colors.black, fontSize: 14)),
                            SizedBox(
                              height: 8,
                            ),
                            Text('Thus ',
                                style: TextStyle(fontSize: 14))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: MaterialButtons(
                        text: 'Enjoy Your Ride!'.tr(),
                        textcolor: Colors.white,
                        meterialColor:const Color.fromARGB(255, 3, 22, 60),
                        onTap: () {},
                        elevationsize: 20,
                        containerheight: 40,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
     
  }
}
