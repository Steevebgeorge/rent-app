part of 'stripe_payment_bloc.dart';

sealed class StripePaymentEvent {}

final class CreatePayment extends StripePaymentEvent {
  final String amount;
  final String currency;

  CreatePayment({required this.amount, required this.currency});
}
