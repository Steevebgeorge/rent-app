// class HotelModel {
//   final String uid;
//   final String name;
//   final String location;
//   final double price;
//   final double rating;
//   final List<String> images;
//   final String description;

//   // Host Info
//   final String hostName;
//   final String hostProfileImage;
//   final String hostPhone;
//   final String hostEmail;

//   // HotelModel type, tags, amenities
//   final String type;
//   final List<String> tags;
//   final List<String> amenities;

//   // Rules & Info
//   final String checkInTime;
//   final String checkOutTime;
//   final String cancellationPolicy;
//   final List<String> houseRules;
//   final List<String> otherInfo;

//   // Location
//   final double latitude;
//   final double longitude;

//   // Optional
//   final bool available;
//   final int reviewCount;
//   final bool featured;

//   HotelModel({
//     required this.uid,
//     required this.name,
//     required this.location,
//     required this.price,
//     required this.rating,
//     required this.images,
//     required this.description,
//     required this.hostName,
//     required this.hostProfileImage,
//     required this.hostPhone,
//     required this.hostEmail,
//     required this.type,
//     required this.tags,
//     required this.amenities,
//     required this.checkInTime,
//     required this.checkOutTime,
//     required this.cancellationPolicy,
//     required this.houseRules,
//     required this.otherInfo,
//     required this.latitude,
//     required this.longitude,
//     this.available = true,
//     this.reviewCount = 0,
//     this.featured = false,
//   });
//   Map<String, dynamic> toJson() => {
//         'uid': uid,
//         'name': name,
//         'location': location,
//         'price': price,
//         'rating': rating,
//         'images': images,
//         'description': description,
//         //
//         'hostName': hostName,
//         'hostProfileImage': hostProfileImage,
//         'hostPhone': hostPhone,
//         'hostEmail': hostEmail,
//         //
//         'type': type,
//         'tags': tags,
//         'amenities': amenities,
//         //
//         'checkInTime': checkInTime,
//         'checkOutTime': checkOutTime,
//         'cancellationPolicy': cancellationPolicy,
//         'houseRules': houseRules,
//         'otherInfo': otherInfo,
//         //
//         'latitude': latitude,
//         'longitude': longitude,
//         //
//         'available': available,
//         'reviewCount': reviewCount,
//         'featured': featured,
//       };

//   factory HotelModel.fromJson(Map<String, dynamic> json) {
//     return HotelModel(
//       uid: json['uid'] ?? '',
//       name: json['name'] ?? '',
//       location: json['location'] ?? '',
//       price: (json['price'] ?? 0).toDouble(),
//       rating: (json['rating'] ?? 0).toDouble(),
//       images: List<String>.from(json['images'] ?? []),
//       description: json['description'] ?? '',
//       hostName: json['hostName'] ?? '',
//       hostProfileImage: json['hostProfileImage'] ?? '',
//       hostPhone: json['hostPhone'] ?? '',
//       hostEmail: json['hostEmail'] ?? '',
//       type: json['type'] ?? '',
//       tags: List<String>.from(json['tags'] ?? []),
//       amenities: List<String>.from(json['amenities'] ?? []),
//       checkInTime: json['checkInTime'] ?? '',
//       checkOutTime: json['checkOutTime'] ?? '',
//       cancellationPolicy: json['cancellationPolicy'] ?? '',
//       houseRules: List<String>.from(json['houseRules'] ?? []),
//       otherInfo: List<String>.from(json['otherInfo'] ?? []),
//       latitude: (json['latitude'] ?? 0).toDouble(),
//       longitude: (json['longitude'] ?? 0).toDouble(),
//       available: json['available'] ?? true,
//       reviewCount: json['reviewCount'] ?? 0,
//       featured: json['featured'] ?? false,
//     );
//   }
// }
