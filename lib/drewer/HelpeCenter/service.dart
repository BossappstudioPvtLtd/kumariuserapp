// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_picker/languages.dart';
import 'package:new_app/components/speak_button.dart';
import 'package:new_app/components/text_add.dart';

final FlutterTts tts = FlutterTts();

class Services extends StatefulWidget {

  const Services({super.key,});

  @override
  ServicesState createState() => ServicesState();
}

class ServicesState extends State<Services> {
  final TextEditingController bookingcontroller = TextEditingController(
      text:
          'Booking: You can book a cab through various methods such as a mobile app, website, or phone call to the cab company. Provide your location, destination, and any other necessary details like the type of vehicle needed or any special requirements.'.tr());
  final TextEditingController confirmationcontroller = TextEditingController(
      text:
          'Confirmation: After booking, youll receive a confirmation message with details like the drivers name, vehicle number, and estimated time of arrival (ETA).'.tr());
  final TextEditingController waitpickupcontroller = TextEditingController(
    text:
        'Wait for Pickup: Wait at the designated pickup location. Keep your phone handy to communicate with the driver if needed.'.tr());
  final TextEditingController ridecontroller = TextEditingController(
      text:
          'Ride: Once the cab arrives, confirm the drivers identity and vehicle details before getting in. Share your destination with the driver, and enjoy your ride.'.tr());
  final TextEditingController paymentcontroller = TextEditingController(
    text:
        "Payment: Payment methods vary depending on the cab service. Some accept cash, while others are cashless and accept payment through the app or card.".tr());
  final TextEditingController feedbackcontroller = TextEditingController(
    text:
        "Feedback: After the ride, you may have the option to rate the driver and provide feedback. This helps maintain service quality.".tr());
  final TextEditingController safetycecontroller = TextEditingController(
    text:
        'Safety: Always prioritize your safety. Share your ride details with a trusted contact, and if you feel uncomfortable during the ride, dont hesitate to ask the driver to stop in a safe location or to contact the authorities if necessary.'.tr());
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
            text: 'Booking'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: bookingcontroller,
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
                tts.speak(bookingcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 20,
          ),
           TextEdt(
            text: 'Confirmation: After booking'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: confirmationcontroller,
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
                tts.speak(confirmationcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
             const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Wait for Pickup'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: waitpickupcontroller,
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
                tts.speak(waitpickupcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Ride'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: ridecontroller,
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
                tts.speak(ridecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Payment Methods'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: paymentcontroller,
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
                tts.speak(paymentcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Feedback'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: feedbackcontroller,
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
                tts.speak(feedbackcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Safety'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: safetycecontroller,
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
                tts.speak(safetycecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
        ],
      ),
    );
  }
}
