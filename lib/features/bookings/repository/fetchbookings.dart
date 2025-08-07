import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_app/features/confirmbooking/models/bookingconfirmmodel.dart';

class FetchBookingRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BookingModel>> fetchMyBookings() async {
    try {
      final snapshot = await _firestore
          .collection('app_Users')
          .doc(_auth.currentUser!.uid)
          .collection('bookings')
          .get();
      return snapshot.docs.map((e) => BookingModel.fromJson(e.data())).toList();
    } catch (e) {
      log('error while fetching bookngs from databsee');
      rethrow;
    }
  }
}
