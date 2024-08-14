import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the package

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

class AdvertisementShow extends StatefulWidget {
  const AdvertisementShow({super.key});

  @override
  AdvertisementShowState createState() => AdvertisementShowState();
}

class AdvertisementShowState extends State<AdvertisementShow> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('advertisements');
  List<Advertisement> _advertisementList = [];
  bool _errorOccurred = false;

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
          _errorOccurred = false;
        });
      } else {
        setState(() {
          _advertisementList = [];
          _errorOccurred = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorOccurred = true;
      });
    }
  }

  void _showAdvertisementDialog(
      BuildContext context, Advertisement advertisement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: advertisement.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.fill, // Use BoxFit.fill here
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  advertisement.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(advertisement.description),
                const SizedBox(height: 10),
                Text('Posted on: ${advertisement.postDate}'),
                Text('Expires on: ${advertisement.expiryDate}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: _errorOccurred
              ? const Center(
                  child: Text(
                    'An error occurred while fetching advertisements.',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : _advertisementList.isEmpty
                  ? const Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 500,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                        ),
                        items: _advertisementList.map((advertisement) {
                          return GestureDetector(
                            onTap: () {
                              _showAdvertisementDialog(
                                  context, advertisement);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: advertisement.imageUrl,
                                fit: BoxFit.fill, // Use BoxFit.fill here
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Text(
                                    'Failed to load image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
        ),
      ],
    );
  }
}
