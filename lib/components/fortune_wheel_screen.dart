import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:new_app/components/animation_mbutton.dart';
import 'package:reward_popup/reward_popup.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  WheelScreenState createState() => WheelScreenState();
}

class WheelScreenState extends State<WheelScreen> {

  StreamController<int> selected = StreamController<int>();
  final List<FortuneItem> items = [
    FortuneItem(
        child: Image.asset(
          "assets/images/gift10.png",
          height: 50,
          width: 50,
        ),
        style: const FortuneItemStyle(
          color: Color.fromARGB(255, 26, 11, 28),
        )),
    FortuneItem(
        child: Image.asset("assets/images/gift9.png", height: 35, width: 35),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 86, 4, 100))),
    FortuneItem(
        child: Image.asset("assets/images/gift8.png", height: 19, width: 19),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 54, 2, 62))),
    FortuneItem(
        child: Image.asset(
          "assets/images/gift10.png",
          height: 50,
          width: 50,
        ),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 26, 11, 28))),
    FortuneItem(
        child: Image.asset("assets/images/gift9.png", height: 35, width: 35),
        style: const FortuneItemStyle(
          color: Color.fromARGB(255, 86, 4, 100),
        )),
    FortuneItem(
        child: Image.asset("assets/images/gift8.png", height: 19, width: 19),
        style: const FortuneItemStyle(color: Color.fromARGB(255, 54, 2, 62))),
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _databaseReference;
  String _imageUrl = '';
  String _giftStatus = '';
  String _giftOfferId = '';
  String _phoneNumber = '';
  String _userName = '';
  String _giftTitle = '';
  String _expiryDate = '';
  String _description = '';
  String _buttonText = 'Received'; // Default button text

  @override
  void initState() {
    super.initState();
    _fetchGiftOffers();
  }

  Future<void> _fetchGiftOffers() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      DataSnapshot snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _phoneNumber = userData['phone'] ?? '';
          _userName = userData['name'] ?? ''; // Fetch the user's name
        });
        if (userData.containsKey('giftOffer')) {
          Map<dynamic, dynamic> giftOffer = userData['giftOffer'] as Map<dynamic, dynamic>;
          setState(() {
            _imageUrl = giftOffer['imageUrl'] ?? '';
            _giftStatus = giftOffer['giftStatus'] ?? '';
            _giftOfferId = giftOffer['id'] ?? '';
            _giftTitle = giftOffer['title'] ?? ''; // Fetch the gift offer title
            _expiryDate = giftOffer['expiryDate'] ?? ''; // Fetch the expiry date
            _description = giftOffer['description'] ?? ''; // Fetch the description
            _buttonText = 'Received'; // Keep the button text as "Received"
          });
        } else {
          setState(() {
            _buttonText = 'Cancel'; // Change the button text to "Cancel" if no gift offer found
          });
          print('No gift offer found for the current user.');
        }
      } else {
        print('BETTER LUCK NEXT TIME.');
      }
    } else {
      print('User not logged in');
    }
  }

  Future<void> _sendGiftOfferData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String currentId = user.uid;
      String phoneNumber = _phoneNumber;
      String giftOfferId = _giftOfferId;
      String giftStatus = _giftStatus;
      String userName = _userName;
      String giftTitle = _giftTitle;
      String expiryDate = _expiryDate;
      String imageUrl = _imageUrl;
      String description = _description;

      // Prepare the data to be sent to the Realtime Database
      Map<String, dynamic> receivedGiftOfferData = {
        'userId': currentId,
        'phone': phoneNumber,
        'userName': userName,
        'giftOfferId': giftOfferId,
        'giftStatus': "received",
        'giftTitle': giftTitle,
        'expiryDate': expiryDate,
        'imageUrl': imageUrl,
        'description': description,
        'receivedAt': DateTime.now().toIso8601String(), // Optional: Store the timestamp of when the offer was received
      };

      // Push the received gift offer data to the 'receivedGiftOffers' node in the Realtime Database
      await FirebaseDatabase.instance.ref().child('receivedGiftOffers').push().set(receivedGiftOfferData);

      // Delete the 'giftOffer' node from the current user's data
      await _databaseReference.child('giftOffer').remove();

      print('Received gift offer data sent to Realtime Database:');
      print(receivedGiftOfferData);
      print('Gift offer deleted from the current user\'s data.');

      // Navigate back to the previous screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 88,
          child: SizedBox(
            height: 170,
            width: 170,
            child: Expanded(
              child: FortuneWheel(
                selected: selected.stream,
                items: items,
                onAnimationEnd: () async {
                  final answer = await showRewardPopup<String>(
                    context,
                    backgroundColor: Colors.transparent,
                    child: Positioned.fill(
                      child: _imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: _imageUrl,
                              fit: BoxFit.cover,
                              height: 200,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : const Center(child: Text("BETTER LUCK NEXT TIME",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 26),)),
                    ),
                    dismissButton: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: MaterialButtonsAnimation(
                        elevationsize: 20,
                        text: _buttonText, // Use the updated button text
                        containerheight: 40,
                        containerwidth: double.infinity,
                        borderRadius: BorderRadius.circular(5),
                        meterialColor: Colors.white,
                        onTap: () async {
                          if (_buttonText == 'Received') {
                            await _sendGiftOfferData(); // Send the gift offer data to Realtime Database and delete it from the user's data
                          } else {
                            Navigator.of(context).pop(); // Dismiss the popup if the button text is "Cancel"
                          }
                        },
                      ),
                    ),
                  );
                  // Use answer if needed
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
          child: const Text('Spin'),
          onPressed: () {
            setState(() {
              selected.add(Fortune.randomInt(0, items.length));
            });
          },
        ),
      ],
    );
  }
}
