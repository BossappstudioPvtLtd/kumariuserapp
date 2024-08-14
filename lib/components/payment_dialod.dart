import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:new_app/comen/common_methords.dart';
import 'package:restart_app/restart_app.dart';



class PaymentDialog extends StatefulWidget
{
  String fareAmount;

  PaymentDialog({super.key,  required this.fareAmount,});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}



class _PaymentDialogState extends State<PaymentDialog>
{
  CommonMethods cMethods = CommonMethods();
   String currentUserTotalTripsCompleted = "";

  getCurrentUserTotalNumberOfTripsCompleted() async {
    DatabaseReference tripRequestsRef =
        FirebaseDatabase.instance.ref().child("tripRequests");

    await tripRequestsRef.once().then((snap) async {
      if (snap.snapshot.value != null) {
        Map<dynamic, dynamic> allTripsMap = snap.snapshot.value as Map;

        List<String> tripsCompletedByCurrentUser = [];

        allTripsMap.forEach((key, value) {
          if (value["status"] != null) {
            if (value["status"] == "ended") {
              if (value["userID"] == FirebaseAuth.instance.currentUser!.uid) {
                tripsCompletedByCurrentUser.add(key);
              }
            }
          }
        });

        setState(() {
          currentUserTotalTripsCompleted =
              tripsCompletedByCurrentUser.length.toString();
        });

        // Update user's total trips completed in the database
        updateUserTotalTripsCompleted(currentUserTotalTripsCompleted);
      }
    });
  }

  updateUserTotalTripsCompleted(String totalTrips) async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await userRef.update({
      "totalTripsCompleted": totalTrips,
      //"giftStatus": "off", 
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentUserTotalNumberOfTripsCompleted();
  }

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
               
            const SizedBox(height: 8,),
            Image.asset("assets/images/moneycurrency.png",height:100,width:100),

            const SizedBox(height: 21,),

             Text(
              "PAY CASH".tr(),
              style: const TextStyle(
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 21,),

            const Divider(
              height: 1.5,
              color: Colors.white70,
              thickness: 1.0,
            ),

            const SizedBox(height: 16,),

            Text(
              "₹${widget.fareAmount}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16,),

             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text("This is fare amount".tr(), textAlign: TextAlign.center,style: const TextStyle(color: Colors.grey),),
                  Text("(₹ ${widget.fareAmount})", textAlign: TextAlign.center,style: const TextStyle(color: Colors.grey),),
                  Text("you have to pay to the driver.".tr(), textAlign: TextAlign.center,style: const TextStyle(color: Colors.grey),),
               
                ],
              ),
            ),
            const SizedBox(height: 31,),

            ElevatedButton(
              onPressed: ()
              {
                
        updateUserTotalTripsCompleted(currentUserTotalTripsCompleted);
                Navigator.pop(context, "paid");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child:  Text(
                "PAY CASH".tr(),
              ),
            ),

            const SizedBox(height: 41,)

          ],
        ),
      ),
    );
  }
}
