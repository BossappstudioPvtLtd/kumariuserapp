import 'package:cloud_firestore/cloud_firestore.dart';
//mport 'package:firebase_auth/firebase_auth.dart';

class DatabaseMathords{
  Future addUser(String userId,Map<String,dynamic>userINfoMap){
    return FirebaseFirestore.instance.collection("User").doc(userId).set(userINfoMap);
  }

  
}