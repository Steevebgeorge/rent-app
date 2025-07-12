class AppUser {
  final String uid;
  final String username;
  final String email;
  final String location;

  AppUser({
    required this.location,
    required this.uid,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'location': location,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      location: json['location'],
    );
  }
}
