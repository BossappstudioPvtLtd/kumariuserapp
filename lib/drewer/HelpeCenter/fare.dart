// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_picker/languages.dart';
import 'package:new_app/components/speak_button.dart';
import 'package:new_app/components/text_add.dart';

final FlutterTts tts = FlutterTts();

class FareDetails extends StatefulWidget {
  const FareDetails({
    super.key,
  });

  @override
  FareDetailsState createState() => FareDetailsState();
}

class FareDetailsState extends State<FareDetails> {
  final TextEditingController farecontroller = TextEditingController(
    text:
        'cabs are equipped with meters that calculate the fare based on the distance traveled and time spent in the cab. The fare typically includes a base fare plus additional charges for distance and time.'.tr(),
  );
  final TextEditingController timebasedfarecontroller = TextEditingController(
      text:
          "Time Based Fare: The charge a flat rate for waiting time, separate from the distance traveled. For example, they might charge a certain amount per minute for waiting time, regardless of whether the taxi is moving or stationary.".tr());

  final TextEditingController additionfarecontroller1 = TextEditingController(
    text:
        'Additional Charges: Cab fares may also include additional charges for tolls, airport fees, late-night surcharges, or extra passengers. These charges are usually added on our company.'.tr(),
  );
  Language initialLang = Language('en', 'English');
  var langList = [];
  var selectedLang;

  @override
  void initState() {
    //langList.clear();
    tts.getVoices.then((value) {
      for (int i = 0; i < value.length; i++) {
        langList.add(value[i]['locale']);
        print(value[i]['locale']);
        print(langList.length);
      }
    });
    tts.setLanguage('en');
    tts.setSpeechRate(0.4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Fare Details".tr()),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        children: [
          const SizedBox(
            height: 20,
          ),
           TextEdt(
            text:'Charches'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: farecontroller,
            maxLines: 5,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                tts.speak(farecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 20,
          ),
           TextEdt(
            text: 'Time Based Fare'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: timebasedfarecontroller,
            maxLines: 5,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                tts.speak(timebasedfarecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Additional Charges'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: additionfarecontroller1,
            maxLines: 5,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                tts.speak(additionfarecontroller1.text);
              });
            },
            child: const SpeakButton(),
          ),
        ],
      ),
    );
  }
}
