import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/constants/routes.dart';
import 'package:rent_app/features/confirmbooking/models/bookingconfirmmodel.dart';

import '../bloc/confirm_booking_bloc.dart';
import '../bloc/confirm_booking_event.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final BookingModel booking;
  const PaymentSuccessScreen({super.key, required this.booking});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConfirmBookingBloc>().add(
          ConfirmBookingSubmitted(booking: widget.booking),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Success')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text('Thank you! Your booking is confirmed.',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.home,
                  (route) => false,
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
