import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Future<void> uploadDummyHotels() async {
  //   final firestore = FirebaseFirestore.instance;

  //   for (var hotel in dummyHotels) {
  //     final hotelId = const Uuid().v1();
  //     try {
  //       await firestore.collection('Hotels').doc(hotelId).set(hotel.toJson());
  //       log('✅ Uploaded hotel: ${hotel.name}');
  //     } catch (e, stackTrace) {
  //       log('❌ Failed to upload hotel: ${hotel.name}',
  //           error: e, stackTrace: stackTrace);
  //     }
  //   }

  //   log("✅ Upload complete");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
