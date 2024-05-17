import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserInfoNav extends StatefulWidget {
  const UserInfoNav({super.key});

  @override
  State<UserInfoNav> createState() => _UserInfoNavState();
}

class _UserInfoNavState extends State<UserInfoNav> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  DatabaseReference? userRef;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      userRef = FirebaseDatabase.instance
          // ignore: deprecated_member_use
          .reference()
          .child('users/${currentUser!.uid}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userRef!.onValue,
        builder: (context, AsyncSnapshot event) {
          if (event.hasData &&
              !event.hasError &&
              event.data.snapshot.value != null) {
            Map data = event.data.snapshot.value;
            return Padding(
              padding: const EdgeInsets.only(
                right: 12,
              ),
              child: Material(
                shadowColor: const Color.fromARGB(255, 3, 22, 60),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                elevation: 10,
                color: Theme.of(context).colorScheme.background,
                child: Row(
                  children: [
                    Material(
                      elevation: 20,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.network("${data['photo']}",
                            // child: Image.network(currentUser!.photoURL!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                         Text(
                          'Hello'.tr(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " ${data['name']}!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black87,
            ));
          }
        });
  }
}
