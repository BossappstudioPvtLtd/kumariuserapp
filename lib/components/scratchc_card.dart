import 'package:flutter/material.dart';
import 'package:new_app/components/rich_text.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCard extends StatefulWidget {
  const ScratchCard({super.key});

  @override
  ScratchCardState createState() => ScratchCardState();
}

class ScratchCardState extends State<ScratchCard> {
  final GlobalKey<ScratcherState> scratchKey = GlobalKey<ScratcherState>();

  @override
  Widget build(BuildContext context) {
    return
      
      Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Center(
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(10),
              child: ClipRRect(
               borderRadius:  BorderRadius.circular(10),
                child: Scratcher(
                  rebuildOnResize: true,
                  accuracy: ScratchAccuracy.high,
                  key: scratchKey,
                  image: Image.asset(
                    "assets/images/scratch.png",
                    fit: BoxFit.cover,
                  ),
                  brushSize: 30,
                  threshold: 50,
                  // ignore: avoid_print
                  onChange: (value) => print("Scratch progress: $value%"),
                  onThreshold: () => print("Threshold reached, you won!"),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 249, 250, 255),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 70,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
                                        Text(
                                          "10 -",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                        Icon(
                                          Icons.currency_rupee,
                                          size: 20,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          "100",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        )
                                      ],
                                    ),
                                    Rich(
                                      text: "*",
                                      text1:
                                          "   Book your next ride and enjoy instant savings with our limited-time cashback offer",
                                    ),
                                    Rich(
                                      text: "*",
                                      text1: "   Only One redemption per user ",
                                    ),
                                    Rich(
                                      text: "*",
                                      text1:
                                          "   Enjoy exclusive discounts or free rides ",
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.amber,
                                    image: const DecorationImage(
                                      image: ExactAssetImage(
                                          'assets/images/cashback.png'),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      
    );
  }
}
