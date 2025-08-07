import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_app/features/confirmbooking/models/bookingconfirmmodel.dart';

class BookingRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> confirmBooking(BookingModel booking) async {
    final userUid = _auth.currentUser!.uid;

    await _firestore
        .collection('app_Users')
        .doc(userUid)
        .collection('bookings')
        .add(booking.toJson());
  }
}