import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveFavouriteRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add hotelId to user's favourites array
  Future<void> saveFavourite(String hotelId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userDoc = _firestore.collection('app_Users').doc(user.uid);

      await userDoc.update({
        'favourites': FieldValue.arrayUnion([hotelId])
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Remove hotelId from user's favourites array
  Future<void> removeFavourite(String hotelId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userDoc = _firestore.collection('app_Users').doc(user.uid);

      await userDoc.update({
        'favourites': FieldValue.arrayRemove([hotelId])
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch user's favourites array
  Future<List<String>> getUserFavourites() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final doc = await _firestore.collection('app_Users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        return List<String>.from(data?['favourites'] ?? []);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
