import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:new_app/Show/advertisement_show.dart';
import 'package:new_app/components/animation_mbutton.dart';

class Advertisement {
  String id;
  String description;
  String title;
  String postDate;
  String expiryDate;
  String imageUrl;

  Advertisement({
    required this.id,
    required this.description,
    required this.title,
    required this.postDate,
    required this.expiryDate,
    required this.imageUrl,
  });

  factory Advertisement.fromMap(Map<dynamic, dynamic> data, String id) {
    return Advertisement(
      id: id,
      description: data['description'],
      title: data['title'],
      postDate: data['postDate'],
      expiryDate: data['expiryDate'],
      imageUrl: data['imageUrl'],
    );
  }
}

class AdvertisementListScreen extends StatefulWidget {
  const AdvertisementListScreen({super.key});

  @override
  _AdvertisementListScreenState createState() =>
      _AdvertisementListScreenState();
}

class _AdvertisementListScreenState extends State<AdvertisementListScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('advertisements');
  List<Advertisement> _advertisementList = [];
  bool _errorOccurred = false; // Flag to track errors

  @override
  void initState() {
    super.initState();
    _fetchAdvertisements();
  }

  void _fetchAdvertisements() async {
    try {
      final DatabaseEvent event = await _databaseReference.once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> advertisementsData =
            snapshot.value as Map<dynamic, dynamic>;
        final List<Advertisement> loadedAdvertisements = [];

        advertisementsData.forEach((id, data) {
          final Advertisement advertisement =
              Advertisement.fromMap(data as Map<dynamic, dynamic>, id);
          loadedAdvertisements.add(advertisement);
        });

        setState(() {
          _advertisementList = loadedAdvertisements;
          _errorOccurred = false; // No error occurred
        });
      } else {
        setState(() {
          _advertisementList = [];
          _errorOccurred = false; // No data, but no error
        });
      }
    } catch (error) {
      setState(() {
        _errorOccurred = true; // Error occurred during fetching
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Color.fromARGB(255, 3, 6, 56),
          ],
        )),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Text(
                    'Advertisements',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdvertisementShow()));
                      },
                      icon: const Icon(Icons.remove_red_eye)),
                ],
              ),
            ),
            Expanded(
              child: _errorOccurred
                  ? const Center(
                      child: Text(
                        'An error occurred while fetching advertisements.',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    )
                  : _advertisementList.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Image.asset("assets/images/7_Error.png"),
                                  Center(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 400,
                                        ),
                                        const Text(
                                          'Error!',
                                          style: TextStyle(
                                              fontSize: 26,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'No advertisements available at the moment.',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MaterialButtonsAnimation(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          containerheight: 40,
                                          containerwidth: 100,
                                          elevationsize: 10,
                                          text: 'Go Back',
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _advertisementList.length,
                          itemBuilder: (context, index) {
                            final advertisement = _advertisementList[index];
                            // Parse the expiry date
                            final DateTime expiryDate = DateFormat('yyyy-MM-dd')
                                .parse(advertisement.expiryDate);
                            final bool isExpired =
                                DateTime.now().isAfter(expiryDate);
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                                  child: Card(
                                    color: Colors.white12,
                                    elevation: 20,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      onTap: () {},
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16)),
                                            child: CachedNetworkImage(
                                              imageUrl: advertisement.imageUrl,
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                         
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: Text(
                                              advertisement.title,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white60),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: Text(
                                              advertisement.description,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16),
                                                child: Text(
                                                  'Posted: ${advertisement.postDate}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green),
                                                ),
                                              ),
                                              isExpired
                                                  ? Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8.0),
                                                        child: AnimatedTextKit(
                                                          totalRepeatCount: 100,
                                                          animatedTexts: [
                                                            ColorizeAnimatedText(
                                                              'Expired',
                                                              textStyle:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              colors: [
                                                                Colors.red,
                                                                Colors.red,
                                                                Colors.white,
                                                                Colors.orange,
                                                                Colors.orange,
                                                              ],
                                                            ),
                                                          ],
                                                          isRepeatingAnimation:
                                                              true,
                                                        ),
                                                      ),
                                                    )
                                                  : Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                8),
                                                        child: Text(
                                                          'Expires on: ${DateFormat.yMMMd().format(expiryDate)}',
                                                          style: const TextStyle(
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
