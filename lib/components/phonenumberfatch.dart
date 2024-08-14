

// ignore_for_file: unused_field, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class PhoneNumberdata extends StatefulWidget {
  const PhoneNumberdata({super.key});

  @override
  PhoneNumberdataState createState() => PhoneNumberdataState();
}

class PhoneNumberdataState extends State<PhoneNumberdata> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  Future<Map<String, dynamic>> fetchPhoneNumbers() async {
    User? currentUser = _auth.currentUser;
    String uid = currentUser?.uid ?? '';

    // Fetch from Firestore
    var firestoreData = await _firestore.collection('User').doc(uid).get();
    String PhoneNumber = firestoreData.data()?['phone'] ??
        ' phone number not  available ';

    return {
      'Firestore': PhoneNumber,
    };
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchPhoneNumbers(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListTile(
            leading:const Icon(Icons.phone_android),
            title: const Text(' Phone '),
            subtitle: Text(snapshot.data?['Firestore'] ?? 'Not found'),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
