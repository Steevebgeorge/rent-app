import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_app/features/booking%20checkout/bloc/stripe_payment_bloc.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';
import 'package:rent_app/paymentsuccess.dart';

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
              builder: (context) => const PaymentSuccessScreen(),
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
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(125, 33, 33, 33)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Booking',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 5),
                  Text('Dates',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Spacer(),
                  Text(
                    '${DateFormat('dd MMMM ').format(selectedDateRange.start)} - ${DateFormat('dd MMMM yyyy').format(selectedDateRange.end)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.meeting_room_sharp),
                  SizedBox(width: 5),
                  Text('Room Type',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Spacer(),
                  Text(snap.type,
                      style: Theme.of(context).textTheme.headlineSmall)
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 5),
                  Text('Phone',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Spacer(),
                  Text(snap.hostPhone,
                      style: Theme.of(context).textTheme.headlineSmall)
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 5),
                  Text('Guests',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Spacer(),
                  Text(
                    guestCount.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Price Details',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.attach_money_rounded),
                  SizedBox(width: 5),
                  Text('Total Price',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Spacer(),
                  Text(
                    '₹$totalPrice',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
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
          spacing: 10,
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
            ),
            Text('${snap.price.toInt().toString()} / per day')
          ],
        ),
        SizedBox(
          child: Row(
            spacing: 2,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Text(snap.rating.toString()),
            ],
          ),
        )
      ],
    );
  }
}
