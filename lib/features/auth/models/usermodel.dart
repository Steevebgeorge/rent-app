class AppUser {
  final String uid;
  final String username;
  final String email;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
    );
  }
}
