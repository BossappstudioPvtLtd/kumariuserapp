import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class ScreanBrightness extends StatefulWidget {
  const ScreanBrightness({super.key});

  @override
  ScreanBrightnessState createState() => ScreanBrightnessState();
}

class ScreanBrightnessState extends State<ScreanBrightness> {
  double _currentBrightness = 0.5;

  @override
  void initState() {
    super.initState();
    _getCurrentBrightness();
  }

  Future<void> _getCurrentBrightness() async {
    try {
      double brightness = await ScreenBrightness().current;
      setState(() {
        _currentBrightness = brightness;
      });
    } catch (e) {
      debugPrint('Failed to get current brightness: $e');
    }
  }

  Future<void> _setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
      setState(() {
        _currentBrightness = brightness;
      });
    } catch (e) {
      debugPrint('Failed to set brightness: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                   
                    height: 100,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 25,right: 25,top: 20),
                          child: Row(
                            children: [
                              Icon(Icons.sunny),
                              Spacer(),
                              Icon(Icons.wb_sunny_outlined,color: Colors.amber,)
                            ],
                          ),
                        ),
                        Slider(
                          autofocus: true,
                          secondaryTrackValue:1.0 ,
                          secondaryActiveColor: Colors.grey,
                          activeColor: Colors.amber,
                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          value: _currentBrightness,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            _setBrightness(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
