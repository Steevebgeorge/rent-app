import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/bookings/repository/fetchbookings.dart';
import 'package:rent_app/features/confirmbooking/models/bookingconfirmmodel.dart';

part 'fetchbookings_event.dart';
part 'fetchbookings_state.dart';

class FetchbookingsBloc extends Bloc<FetchbookingsEvent, FetchbookingsState> {
  final FetchBookingRepository fetchBookingRepository =
      FetchBookingRepository();
  FetchbookingsBloc() : super(FetchbookingsInitial()) {
    on<FetchUserbookingsRequested>(_bookingsdetailsrequested);
  }

  Future<void> _bookingsdetailsrequested(FetchUserbookingsRequested event,
      Emitter<FetchbookingsState> emit) async {
    emit(FetchBookingsLoading());
    try {
      final bookings = await fetchBookingRepository.fetchMyBookings();
      emit(FetchBookingSuccess(bookings: bookings));
    } catch (e) {
      emit(FetchBookingError(error: 'Failed to fetch bookings'));
      log('Error in fetch booking bloc: $e');
    }
  }
}
