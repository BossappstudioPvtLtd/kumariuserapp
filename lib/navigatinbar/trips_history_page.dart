import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TripsHistoryPage extends StatefulWidget {
  const TripsHistoryPage({super.key});

  @override
  State<TripsHistoryPage> createState() => _TripsHistoryPageState();
}

class _TripsHistoryPageState extends State<TripsHistoryPage> {
  final completedTripRequestsOfCurrentUser =
      FirebaseDatabase.instance.ref().child("tripRequests");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 3, 22, 60),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
             Text(
              "Trips History".tr(),
              style:const TextStyle(fontSize: 30, color: Colors.grey),
            ),
            StreamBuilder(
              stream: completedTripRequestsOfCurrentUser.onValue,
              builder: (BuildContext context, snapshotData) {
                if (snapshotData.hasError) {
                  return const Center(
                    child: Text(
                      "Error Occurred.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!snapshotData.hasData ||
                    snapshotData.data!.snapshot.value == null) {
                  return const Error(); // Display your custom widget here
                }

                Map dataTrips = snapshotData.data!.snapshot.value as Map;
                List tripsList = [];
                dataTrips.forEach(
                    (key, value) => tripsList.add({"key": key, ...value}));

                return Column(
                  children: [
                    // Add this SizedBox conditionally
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tripsList.length,
                      itemBuilder: (context, index) {
                        if (tripsList[index]["status"] != null &&
                            tripsList[index]["status"] == "ended" &&
                            tripsList[index]["userID"] ==
                                FirebaseAuth.instance.currentUser!.uid) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: const Color.fromARGB(255, 3, 22, 60),
                              elevation: 2,
                              shadowColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade800),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Date: ${tripsList[index]["publishDateTime"].split(' ')[0]}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                             Text(
                                              "Time: ${tripsList[index]["publishDateTime"].split(' ')[1]}",
                                               style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                             ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //pickup - fare amount
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/tracking.png',
                                          height: 16,
                                          width: 16,
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        Expanded(
                                          child: Text(
                                            tripsList[index]["pickUpAddress"]
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "₹ ${tripsList[index]["fareAmount"]}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    //dropoff
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/placeholder(1).png',
                                          height: 16,
                                          width: 16,
                                        ),
                                        const SizedBox(
                                          width: 18,
                                        ),
                                        Expanded(
                                          child: Text(
                                            tripsList[index]["dropOffAddress"]
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Define your custom widget
class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/file.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
           Positioned(
            bottom: 290,
        left: 20,
            child: Text(
              'Your Files Empty'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            child: Text(
              'Oops! The file you are \n'
              'looking for cannot be found...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
