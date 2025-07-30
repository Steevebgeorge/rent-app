import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String userName;
  final num rating;
  final String comment;
  final Timestamp createdAt;

  ReviewModel({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt,
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['userName'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] as Timestamp,
    );
  }
}
