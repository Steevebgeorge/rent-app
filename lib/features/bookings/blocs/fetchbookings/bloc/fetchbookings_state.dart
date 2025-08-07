part of 'fetchbookings_bloc.dart';

sealed class FetchbookingsState {}

final class FetchbookingsInitial extends FetchbookingsState {}

final class FetchBookingsLoading extends FetchbookingsState {}

final class FetchBookingSuccess extends FetchbookingsState {
  final List<BookingModel> bookings;

  FetchBookingSuccess({required this.bookings});
}

final class FetchBookingError extends FetchbookingsState {
  final String error;

  FetchBookingError({required this.error});
}
