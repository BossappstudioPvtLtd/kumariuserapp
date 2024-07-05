// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_picker/languages.dart';
import 'package:new_app/components/speak_button.dart';
import 'package:new_app/components/text_add.dart';

final FlutterTts tts = FlutterTts();

class SafetyAccident extends StatefulWidget {

  const SafetyAccident({super.key,});

  @override
  SafetyAccidentState createState() => SafetyAccidentState();
}

class SafetyAccidentState extends State<SafetyAccident> {
  final TextEditingController seatbeltusagecontroller = TextEditingController(
      text:"Seatbelt Usage: Always remind passengers to fasten their seatbelts before the journey begins. As a driver, ensure you are also wearing your seatbelt at all times.".tr(),);
  
  final TextEditingController speedlimitscontroller = TextEditingController(
    text:
        'Speed Limits: Emphasize the importance of obeying speed limits and driving at a safe and reasonable speed for the conditions.'.tr()
  );
  final TextEditingController distractioncontroller = TextEditingController(
      text:
          'Distraction-Free Driving: Encourage drivers to avoid distractions such as using mobile phones, eating, or adjusting the radio while driving.Maintaining.'.tr());
  final TextEditingController emergencycontroller = TextEditingController(
    text:
        "Emergency Procedures: Provide guidance on what to do in case of emergencies, such as breakdowns, accidents, or medical emergencies involving passengers.".tr() );
  final TextEditingController aggressivecontroller = TextEditingController(
    text:
        "Handling Aggressive Behavior: The drivers on how to handle aggressive or unruly passengers without escalating the situation.".tr());
  final TextEditingController emergencycontactcontroller = TextEditingController(
    text:
        'Emergency Contact Information: Ensure drivers have access to emergency contact numbers for law enforcement, medical services, and the cab company.'.tr());

 final TextEditingController fatiguecontroller = TextEditingController(
    text:
"Fatigue Management: Educate drivers on the dangers of driving while fatigued and encourage them to take breaks when needed.Alcohol and Drug Policy: Clearly state the company's policy regarding alcohol and drug use, emphasizing zero tolerance while on duty.".tr());

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
        title:  Text("Services".tr()),
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
            text: 'Seat Belt'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: seatbeltusagecontroller,
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
                tts.speak(seatbeltusagecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 20,
          ),
           TextEdt(
            text: 'Speed Limits'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: speedlimitscontroller,
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
                tts.speak(speedlimitscontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
           TextEdt(
            text: 'Distraction'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: distractioncontroller,
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
                tts.speak(distractioncontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Emergency'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: emergencycontroller,
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
                tts.speak(emergencycontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Aggressive'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: aggressivecontroller,
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
                tts.speak(aggressivecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Emergency Contact'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: emergencycontactcontroller,
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
                tts.speak(emergencycontactcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Fatigue Management'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: fatiguecontroller,
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
                tts.speak(fatiguecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
        ],
      ),
    );
  }
}
