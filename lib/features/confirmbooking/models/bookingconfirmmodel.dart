class BookingModel {
  final String userId;
  final String hotelId;
  final String hotelName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int totalPrice;
  final String paymentStatus;
  final DateTime createdAt;

  BookingModel({
    required this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.paymentStatus,
    required this.createdAt,
  });

  /// Convert BookingModel → JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create BookingModel from Firestore JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      userId: json['userId'],
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      guests: json['guests'],
      totalPrice: json['totalPrice'],
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
