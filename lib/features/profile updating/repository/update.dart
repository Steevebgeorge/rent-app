import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileUpdateRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateDetails({
    required String username,
    required String email,
    required String location,
  }) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      await firestore.collection('app_Users').doc(uid).update({
        "username": username,
        "email": email,
        "location": location,
      });
    } catch (e) {
      log("Error updating profile: ${e.toString()}");
      rethrow;
    }
  }
}
