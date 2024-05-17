// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_picker/languages.dart';
import 'package:new_app/components/speak_button.dart';
import 'package:new_app/components/text_add.dart';

final FlutterTts tts = FlutterTts();

class GuideBook extends StatefulWidget {
  final String text;
  const GuideBook({super.key, required this.text});

  @override
  GuideBookState createState() => GuideBookState();
}

class GuideBookState extends State<GuideBook> {
  final TextEditingController createaccountcontroller = TextEditingController(
      text:
          'Create an Account, Once downloaded, open the app and follow the instructions to create an account. Youll need to provide your email, phone number.'.tr());
  final TextEditingController destinationcontroller = TextEditingController(
      text:
          'Enter Your Destination: Use the apps interface to input your destination. You can either type in the address or select it on the map.'.tr());
  final TextEditingController rideoptioncontroller = TextEditingController(
    text:
        'Choose Your Ride Option: Most apps offer various options such as economy, premium, or shared rides. Select the option that suits your needs and budget.'.tr());
  final TextEditingController bookingcontroller = TextEditingController(
      text:
          'Confirm Your Booking: After selecting your ride option, the app will show you the estimated fare and wait time. Confirm your booking to request a ride.'.tr());
  final TextEditingController trackridecontroller = TextEditingController(
    text:
        "Track Your Ride: Once your booking is confirmed, youll be able to track your ride in real-time on the app. Youll see the drivers name, photo, and the vehicle details.".tr());
  final TextEditingController enjoyridecontroller = TextEditingController(
    text:
        "Enjoy Your Ride: Once your ride arrives, hop in, and enjoy the journey to your destination. The app will handle the payment automatically through the payment method you provided during account setup.".tr());
  final TextEditingController rateexperiencecontroller = TextEditingController(
    text:
        'Rate Your Experience: After your ride, youll usually have the option to rate your driver and provide feedback. This helps maintain the quality of service within the ride-hailing community.'.tr());
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
        title:  Text("Guide Book".tr()),
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
            text: 'Create an Account'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: createaccountcontroller,
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
                tts.speak(createaccountcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 20,
          ),
           TextEdt(
            text: 'Destination'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: destinationcontroller,
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
                tts.speak(destinationcontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
           TextEdt(
            text: 'Ride Option'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: rideoptioncontroller,
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
                tts.speak(rideoptioncontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Confirm Your Booking'.tr(),
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
            height: 10,
          ),
           TextEdt(
            text: 'Track Your Ride'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: trackridecontroller,
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
                tts.speak(trackridecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Enjoy Your Ride'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: enjoyridecontroller,
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
                tts.speak(enjoyridecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
          const SizedBox(
            height: 10,
          ),
           TextEdt(
            text: 'Rating'.tr(),
            fontSize: 16,
            color: null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: rateexperiencecontroller,
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
                tts.speak(rateexperiencecontroller.text);
              });
            },
            child: const SpeakButton(),
          ),
        ],
      ),
    );
  }
}
