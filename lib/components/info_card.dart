// ignore_for_file: unused_field, unused_element, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:new_app/components/text_add.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    super.key,
    required this.name,
    // ignore: non_constant_identifier_names
    required this.Profession,
  });
  // ignore: non_constant_identifier_names
  final String name, Profession;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  DatabaseReference? userRef;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      userRef = FirebaseDatabase.instance
          .reference()
          .child('users/${currentUser!.uid}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentUser == null || userRef == null
        ? const Center(child: Text('No user logged in'))
        : StreamBuilder(
            stream: userRef!.onValue,
            builder: (context, AsyncSnapshot event) {
              if (event.hasData &&
                  !event.hasError &&
                  event.data.snapshot.value != null) {
                Map data = event.data.snapshot.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 20),
                      child: ListTile(
                        leading: Material(
                          elevation: 20,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network("${data['photo']}",
                                // child: Image.network(currentUser!.photoURL!,
                                width: 57,
                                height: 70,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  const  SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: TextEdt(
                        text:
                            ' ${data['name']}', //"${currentUser!.displayName}",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
  }
}
