
//  showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext context) {
//           return Stack(
//             children: [
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   height: 300,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.black87,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       topRight: Radius.circular(16),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white24,
//                         blurRadius: 15.0,
//                         spreadRadius: 0.5,
//                         offset: Offset(0.7, 0.7),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 18),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         // Trip status display text
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               tripStatusDisplay,
//                               style: const TextStyle(
//                                 fontSize: 19,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 19,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             ClipOval(
//                               child: Image.network(
//                                 photoDriver == ''
//                                     ? "https://firebasestorage.googleapis.com/v0/b/myapiprojects-425308.appspot.com/o/drivericon.png?alt=media&token=06d831a7-7b31-42f4-996d-9412a922b368"
//                                     : photoDriver,
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 8,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   nameDriver,
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 Text(
//                                   carDetailsDriver,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 19,
//                         ),
//                         const Divider(
//                           height: 1,
//                           color: Colors.white70,
//                           thickness: 1,
//                         ),
//                         const SizedBox(
//                           height: 19,
//                         ),
//                         // Call driver button
//                         GestureDetector(
//                           onTap: () {
//                             launchUrl(Uri.parse("tel://$phoneNumberDriver"));
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 50,
//                                 width: 50,
//                                 decoration: const BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(25)),
//                                 ),
//                                 child: const Padding(
//                                   padding: EdgeInsets.only(right: 10),
//                                   child: CircleAvatar(
//                                     radius: 18,
//                                     backgroundColor: Colors.green,
//                                     child: CircleAvatar(
//                                       radius: 15,
//                                       backgroundColor: Colors.black,
//                                       child: Icon(
//                                         Icons.phone,
//                                         color: Colors.green,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 11,
//                               ),
//                               const Text(
//                                 "Call",
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );