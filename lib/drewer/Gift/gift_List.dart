import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:new_app/components/animation_mbutton.dart';
import 'package:new_app/drewer/Gift/gift_details.dart';

class GiftOfferListScreen extends StatefulWidget {
  const GiftOfferListScreen({super.key});

  @override
  _GiftOfferListScreenState createState() => _GiftOfferListScreenState();
}

class _GiftOfferListScreenState extends State<GiftOfferListScreen>
    with WidgetsBindingObserver {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('giftOffers');
  late Future<List<Map<String, dynamic>>> _giftOffersList;
  final Map<String, DateTime> _lastTapTimes = {};
  final String _sharedPrefsKey = 'last_tap_times';

  int _countdown = 30; // Countdown starts from 10
  Timer? _timer;
  bool _isButtonEnabled = false; // Initially, the button is disabled

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLastTapTimes();
    _giftOffersList = _fetchGiftOffers();
    _startCountdown(); // Start the countdown when the widget is initialized
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveLastTapTimes();
    } else if (state == AppLifecycleState.resumed) {
      _loadLastTapTimes();
    }
  }

  Future<void> _loadLastTapTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString(_sharedPrefsKey);
    if (storedData != null) {
      final data = jsonDecode(storedData);
      setState(() {
        _lastTapTimes.addAll(data.map<String, DateTime>(
            (key, value) => MapEntry(key, DateTime.parse(value))));
      });
    }
  }

  Future<void> _saveLastTapTimes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _sharedPrefsKey,
        jsonEncode(_lastTapTimes
            .map((key, value) => MapEntry(key, value.toIso8601String()))));
  }

  Future<List<Map<String, dynamic>>> _fetchGiftOffers() async {
    final snapshot = await _database.once();
    if (snapshot.snapshot.value != null) {
      return (snapshot.snapshot.value as Map)
          .values
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isButtonEnabled = true; // Enable the button when countdown reaches 0
          _timer?.cancel(); // Stop the timer
        }
      });
    });
  }

  void _onTapOffer(String offerId) async {
    if (!_isButtonEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please wait until the countdown is over.'),
      ));
      return;
    }

    final now = DateTime.now();
    final lastTap = _lastTapTimes[offerId];
    if (lastTap != null && now.difference(lastTap).inSeconds < 24 * 3600) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Wait ${24 - now.difference(lastTap).inHours} hours before tapping again.'),
      ));
      return;
    }

    setState(() => _lastTapTimes[offerId] = now);
    await _saveLastTapTimes();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const GiftPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 17, 93, 155),
            Color.fromARGB(255, 3, 6, 56)
          ],
        )),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back)),
                const Text("Gift Offers", style: TextStyle(fontSize: 26)),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _giftOffersList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No gift offers available'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final offer = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: offer['imageUrl'],
                                      width: 100,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Title: ${offer['title']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Description: ${offer['description']}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Post Date: ${offer['postDate']}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Expiry Date: ${offer['expiryDate']}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: MaterialButtonsAnimation(
                                  text: _countdown > 0
                                      ? 'Wait $_countdown s'
                                      : 'Select',
                                  containerheight: 50,
                                  containerwidth: 150,
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: _isButtonEnabled
                                      ? () =>  Navigator.push(
        context, MaterialPageRoute(builder: (context) => const GiftPage()))
                                      : null, // Disable tap when button is not enabled
                                  elevationsize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
