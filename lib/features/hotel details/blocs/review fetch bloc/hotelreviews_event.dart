part of 'hotelreviews_bloc.dart';

sealed class FetchHotelreviewsEvent {
  const FetchHotelreviewsEvent();
}

class FetchHotelreviews extends FetchHotelreviewsEvent {
  final String hotelId;

  const FetchHotelreviews({required this.hotelId});
}
