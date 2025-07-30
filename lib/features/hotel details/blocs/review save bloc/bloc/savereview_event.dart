part of 'savereview_bloc.dart';

sealed class SavereviewEvent {}

class SaveUserReview extends SavereviewEvent {
  final String hotelId;
  final String review;
  final num rating;

  final String userName;

  SaveUserReview(
      {required this.hotelId,
      required this.review,
      required this.rating,
      required this.userName});
}
