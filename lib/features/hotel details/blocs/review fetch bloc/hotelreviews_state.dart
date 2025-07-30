part of 'hotelreviews_bloc.dart';

sealed class HotelreviewsState {}

final class HotelreviewsInitial extends HotelreviewsState {}

final class HotelreviewsLoading extends HotelreviewsState {}

final class HotelreviewsFetched extends HotelreviewsState {
  final List<ReviewModel> reviews;

  HotelreviewsFetched({required this.reviews});
}

final class HotelreviewsLoadingError extends HotelreviewsState {
  final String error;

  HotelreviewsLoadingError({required this.error});
}
