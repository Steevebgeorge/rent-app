import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_app/features/bookings/blocs/fetchbookings/bloc/fetchbookings_bloc.dart';
import 'package:rent_app/features/confirmbooking/models/bookingconfirmmodel.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchbookingsBloc>().add(FetchUserbookingsRequested());
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FetchbookingsBloc, FetchbookingsState>(
        builder: (context, state) {
          if (state is FetchBookingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchBookingSuccess) {
            if (state.bookings.isEmpty) {
              return const Center(child: Text('No bookings found.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return _buildBookingCard(context, booking);
              },
            );
          } else if (state is FetchBookingError) {
            return Center(child: Text(state.error));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.hotelName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 18, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Check-in: ${_formatDate(booking.checkIn.toString())}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.logout, size: 18, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Check-out: ${_formatDate(booking.checkOut.toString())}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.group, size: 18, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Guests: ${booking.guests}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.paymentStatus.toUpperCase(),
                  style: TextStyle(
                    color: booking.paymentStatus == 'paid'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${booking.totalPrice}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
