import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_app/features/hotel%20details/models/hotelreviewmodel.dart';

class HotelReviewRepository {
  Future<List<ReviewModel>> fetchReviews(String hotelId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Hotels')
        .doc(hotelId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ReviewModel.fromJson(doc.data()))
        .toList();
  }
}
