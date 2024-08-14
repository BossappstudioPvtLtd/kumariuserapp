import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:new_app/components/animation_mbutton.dart';
import 'package:reward_popup/reward_popup.dart';

class RiderHistory1 extends StatefulWidget {
  const RiderHistory1({super.key});

  @override
  State<RiderHistory1> createState() => _RiderHistory1State();
}

class _RiderHistory1State extends State<RiderHistory1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _databaseReference;
  Map<dynamic, dynamic>? _giftOffer;

  @override
  void initState() {
    super.initState();
    _fetchGiftOffers();
  }

  Future<void> _fetchGiftOffers() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Reference to the user's gift offers
      _databaseReference = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      DataSnapshot snapshot = await _databaseReference.get();

      // Check if the snapshot has data
      if (snapshot.exists) {
        // Print the full snapshot to see what data is returned
        print("Snapshot Value: ${snapshot.value}");

        // Assuming the snapshot value is a Map
        Map<dynamic, dynamic>? giftOffer = snapshot.value as Map<dynamic, dynamic>?;

        // Check if giftOffer is not null and has data
        if (giftOffer != null && giftOffer.isNotEmpty) {
          // Set the gift offer data
          setState(() {
            _giftOffer = giftOffer;
          });

          print("Gift Offer:========================= $giftOffer");
        } else {
          print('Gift offer is null or empty.');
        }
      } else {
        print('No gift offers found for the current user.');
      }
    } else {
      print('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reward Popup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press the button to view the gift offer',
              style: TextStyle(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_giftOffer != null) {
                  final answer = await showRewardPopup<String>(
                    context,
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: _giftOffer!["imageUrl"] ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          color: Colors.black54,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _giftOffer!["title"] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _giftOffer!["description"] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Posted on: ${_giftOffer!["postDate"] ?? ''}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                "Expires on: ${_giftOffer!["expiryDate"] ?? ''}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 20),
                              MaterialButtonsAnimation(
                                elevationsize: 20,
                                text: 'Close',
                                containerheight: 40,
                                containerwidth: double.infinity,
                                borderRadius: BorderRadius.circular(5),
                                meterialColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  // Use the answer if needed
                } else {
                  print('No gift offer data available.');
                }
              },
              child: const Text('Show Gift Offer'),
            ),
          ],
        ),
      ),
    );
  }
}
