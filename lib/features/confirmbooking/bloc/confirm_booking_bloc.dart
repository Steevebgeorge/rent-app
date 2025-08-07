import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/confirmbooking/bloc/confirm_booking_event.dart';
import 'package:rent_app/features/confirmbooking/bloc/confirm_booking_state.dart';
import 'package:rent_app/features/confirmbooking/repository/confirm.dart'; // BookingRepository

class ConfirmBookingBloc
    extends Bloc<ConfirmBookingEvent, ConfirmBookingState> {
  final BookingRepository _repository = BookingRepository();

  ConfirmBookingBloc() : super(ConfirmBookingInitial()) {
    on<ConfirmBookingEvent>(_onConfirmBooking);
  }

  Future<void> _onConfirmBooking(
      ConfirmBookingEvent event, Emitter<ConfirmBookingState> emit) async {
    emit(ConfirmBookingLoading());
    try {
      if (event is ConfirmBookingSubmitted) {
        await _repository.confirmBooking(event.booking);
        emit(ConfirmBookingSuccess());
      }
    } catch (e) {
      emit(ConfirmBookingFailure(e.toString()));
    }
  }
}
