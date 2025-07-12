import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';

class LoadHotelRepository {
  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;

  Future<List<HotelModel>> fetchHotels() async {
    final snapshot = await _firebaseStorage.collection('Hotels').get();
    return snapshot.docs
        .map((e) => HotelModel.fromJson(
              e.data(),
            ))
        .toList();
  }
}
