part of 'stripe_payment_bloc.dart';

sealed class StripePaymentState {}

final class StripePaymentInitial extends StripePaymentState {}

final class PaymentLoading extends StripePaymentState {}

final class PaymentSuccess extends StripePaymentState {}

final class PaymentError extends StripePaymentState {
  final String error;
  PaymentError({required this.error});
}
