import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_app/features/hotel%20details/models/hotelreviewmodel.dart';

class SaveUserReviewRepository {
  Future<void> saveReview({
    required String hotelId,
    required String comment,
    required num rating,
    required String userName,
  }) async {
    final reviewData = ReviewModel(
        userName: userName,
        rating: rating,
        comment: comment,
        createdAt: Timestamp.now());

    try {
      await FirebaseFirestore.instance
          .collection('Hotels')
          .doc(hotelId)
          .collection('reviews')
          .add(reviewData.toJson());
    } catch (e) {
      throw Exception('Failed to save review: $e');
    }
  }
}
