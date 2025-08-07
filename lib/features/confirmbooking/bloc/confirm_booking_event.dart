import 'package:rent_app/features/confirmbooking/models/bookingconfirmmodel.dart';

abstract class ConfirmBookingEvent {}

class ConfirmBookingSubmitted extends ConfirmBookingEvent {
  final BookingModel booking;

  ConfirmBookingSubmitted({required this.booking});
}
