import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_app/features/booking%20checkout/screens/checkoutpage.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';

class BookingScreen extends StatefulWidget {
  final HotelModel snap;
  const BookingScreen({super.key, required this.snap});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? selectedDateRange;
  int _guestCount = 1;

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDateRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  void _incrementGuest() {
    if (_guestCount < 5) {
      setState(() {
        _guestCount++;
      });
    }
  }

  void _decrementGuest() {
    if (_guestCount > 1) {
      setState(() {
        _guestCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final int pricePerDay = widget.snap.price.toInt();

    int totalDays = 0;
    int totalPrice = 0;

    if (selectedDateRange != null) {
      totalDays =
          selectedDateRange!.end.difference(selectedDateRange!.start).inDays;
      if (totalDays == 0) totalDays = 1;
      totalPrice = totalDays * pricePerDay;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Request to book',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Date',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              selectedDateRange == null
                  ? Center(
                      child: GestureDetector(
                        onTap: _pickDateRange,
                        child: Container(
                          width: size.width * 0.8,
                          height: size.height * 0.1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(71, 158, 158, 158),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(width: 10),
                              Text(
                                'Select Dates',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: _pickDateRange,
                          child: Container(
                            width: size.width * 0.4,
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(71, 158, 158, 158),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Check-In',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd MMMM yyyy')
                                      .format(selectedDateRange!.start),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickDateRange,
                          child: Container(
                            width: size.width * 0.4,
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(71, 158, 158, 158),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Check-Out',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd MMMM yyyy')
                                      .format(selectedDateRange!.end),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Guests',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 120,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(20, 158, 158, 158),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _decrementGuest,
                          child: Container(
                            alignment: Alignment.center,
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: _guestCount > 1
                                  ? Colors.grey
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          '$_guestCount',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        GestureDetector(
                          onTap: _incrementGuest,
                          child: Container(
                            alignment: Alignment.center,
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: _guestCount < 5
                                  ? Colors.grey
                                  : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.09),
              Text(
                'Payment Details',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (selectedDateRange != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Days:'),
                        Text('$totalDays'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price per day:'),
                        Text('₹$pricePerDay'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Cost:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹$totalPrice',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            if (selectedDateRange == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Select Check-in and Check-out dates'),
                ),
              );
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookingCheckOutScreen(
                  snap: widget.snap,
                  selectedDateRange: selectedDateRange!,
                  guestCount: _guestCount,
                  totalPrice: totalPrice,
                ),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Checkout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
