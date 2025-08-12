import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_app/features/booking%20checkout/bloc/stripe_payment_bloc.dart';
import 'package:rent_app/features/confirmbooking/models/bookingconfirmmodel.dart';
import 'package:rent_app/features/confirmbooking/screens/paymentsuccess.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';

class BookingCheckOutScreen extends StatelessWidget {
  final HotelModel snap;
  final DateTimeRange selectedDateRange;
  final int guestCount;
  final int totalPrice;

  const BookingCheckOutScreen({
    super.key,
    required this.snap,
    required this.selectedDateRange,
    required this.guestCount,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<StripePaymentBloc, StripePaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment Successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(
                booking: BookingModel(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  hotelId: snap.uid,
                  hotelName: snap.name,
                  checkIn: selectedDateRange.start,
                  checkOut: selectedDateRange.end,
                  guests: guestCount,
                  totalPrice: totalPrice,
                  paymentStatus: 'paid',
                  createdAt: DateTime.now(),
                ),
              ),
            ),
          );
        } else if (state is PaymentError) {
          log(state.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PaymentLoading;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Checkout'),
            actions: const [Icon(Icons.more_vert_outlined)],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 30),
                  child: CheckoutTitleWidgets(snap: snap),
                ),
                DetailsContainer(
                  size: size,
                  selectedDateRange: selectedDateRange,
                  snap: snap,
                  guestCount: guestCount,
                  totalPrice: totalPrice,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<StripePaymentBloc>().add(CreatePayment(
                          amount: totalPrice.round().toString(),
                          currency: 'USD'));
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: isLoading ? Colors.grey : Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Confirm Payment',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class DetailsContainer extends StatelessWidget {
  const DetailsContainer({
    super.key,
    required this.size,
    required this.selectedDateRange,
    required this.snap,
    required this.guestCount,
    required this.totalPrice,
  });

  final Size size;
  final DateTimeRange selectedDateRange;
  final HotelModel snap;
  final int guestCount;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: size.width * 0.9,
        // Removed fixed height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(125, 33, 33, 33),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Booking',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Dates
              Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 5),
                  Text('Dates',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      '${DateFormat('dd MMMM ').format(selectedDateRange.start)} - ${DateFormat('dd MMMM yyyy').format(selectedDateRange.end)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Room Type
              Row(
                children: [
                  const Icon(Icons.meeting_room_sharp),
                  const SizedBox(width: 5),
                  Text('Room Type',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      snap.type,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Phone
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 5),
                  Text('Phone',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      snap.hostPhone,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Guests
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 5),
                  Text('Guests',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  Text(
                    guestCount.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Divider(),
              const SizedBox(height: 10),

              Text(
                'Price Details',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.attach_money_rounded),
                  const SizedBox(width: 5),
                  Text('Total Price',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  Text(
                    '₹$totalPrice',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutTitleWidgets extends StatelessWidget {
  const CheckoutTitleWidgets({
    super.key,
    required this.snap,
  });

  final HotelModel snap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              snap.images[0],
              height: 120,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              snap.name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              snap.location,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text('${snap.price.toInt()} / per day')
          ],
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            Text(snap.rating.toString()),
          ],
        )
      ],
    );
  }
}
