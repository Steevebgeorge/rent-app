abstract class ConfirmBookingState {}

class ConfirmBookingInitial extends ConfirmBookingState {}

class ConfirmBookingLoading extends ConfirmBookingState {}

class ConfirmBookingSuccess extends ConfirmBookingState {}

class ConfirmBookingFailure extends ConfirmBookingState {
  final String error;
  ConfirmBookingFailure(this.error);
}
