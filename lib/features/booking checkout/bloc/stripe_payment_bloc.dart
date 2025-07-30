import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:rent_app/keys.dart';

part 'stripe_payment_event.dart';
part 'stripe_payment_state.dart';

class StripePaymentBloc extends Bloc<StripePaymentEvent, StripePaymentState> {
  StripePaymentBloc() : super(StripePaymentInitial()) {
    on<CreatePayment>(_onCreatePayment);
  }

  Future<void> _onCreatePayment(
      CreatePayment event, Emitter<StripePaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final intendPaymentData =
          await makeIntentForPayment(event.amount, event.currency);

      if (intendPaymentData == null ||
          !intendPaymentData.containsKey("client_secret")) {
        emit(PaymentError(error: "Failed to create Payment Intent"));
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: intendPaymentData["client_secret"],
          style: ThemeMode.system,
          merchantDisplayName: "Company Name",
        ),
      );

      await showPaymentSheet(emit);
    } catch (e) {
      log(e.toString());
      emit(PaymentError(error: e.toString()));
    }
  }

  Future<Map<String, dynamic>?> makeIntentForPayment(
      String amount, String currency) async {
    try {
      final paymentInfo = {
        "amount": (int.parse(amount) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": 'card',
      };
      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      log("Stripe response: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      log("Error creating intent: $e");
      return null;
    }
  }

  Future<void> showPaymentSheet(Emitter<StripePaymentState> emit) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      emit(PaymentSuccess());
    } on StripeException catch (error) {
      log("Stripe Exception: ${error.error.localizedMessage}");
      emit(PaymentError(
          error: error.error.localizedMessage ?? "Payment cancelled"));
    } catch (e) {
      log("Unknown error: $e");
      emit(PaymentError(error: e.toString()));
    }
  }
}
