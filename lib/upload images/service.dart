// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rent_app/upload%20images/values.dart';
// import 'package:uuid/uuid.dart';

// void uploadDummyHotels() async {
//   final firestore = FirebaseFirestore.instance;
//   for (var hotel in dummyHotels) {
//     final hotelId = Uuid().v1();

//     firestore.collection('Hotels').doc(hotelId).set(hotel.toJson());
//     log('uploaded hotels');
//   }
// }
