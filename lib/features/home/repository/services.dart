import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_app/features/auth/models/usermodel.dart';

class LoadUserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUser?> loadUserData() async {
    try {
      log('Loading user Data');
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;
      final doc = await _firestore.collection('app_Users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      log('Error Loading User Data');
    }
    return null;
  }
}
