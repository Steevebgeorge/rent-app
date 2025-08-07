class BookingModel {
  final String checkIn;
  final String checkOut;
  final String createdAt;
  final int guests;
  final String hotelId;
  final String hotelName;
  final String paymentStatus;
  final int totalPrice;
  final String userId;

  BookingModel({
    required this.checkIn,
    required this.checkOut,
    required this.createdAt,
    required this.guests,
    required this.hotelId,
    required this.hotelName,
    required this.paymentStatus,
    required this.totalPrice,
    required this.userId,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      checkIn: map['checkIn'] ?? '',
      checkOut: map['checkOut'] ?? '',
      createdAt: map['createdAt'] ?? '',
      guests: map['guests'] ?? 0,
      hotelId: map['hotelId'] ?? '',
      hotelName: map['hotelName'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      totalPrice: map['totalPrice'] ?? 0,
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checkIn': checkIn,
      'checkOut': checkOut,
      'createdAt': createdAt,
      'guests': guests,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'paymentStatus': paymentStatus,
      'totalPrice': totalPrice,
      'userId': userId,
    };
  }
}
