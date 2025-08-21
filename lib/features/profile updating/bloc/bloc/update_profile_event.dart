part of 'update_profile_bloc.dart';

class UpdateProfileEvent {}

class OnUpdatePress extends UpdateProfileEvent {
  final String email;
  final String userName;
  final String location;

  OnUpdatePress({
    required this.email,
    required this.userName,
    required this.location,
  });
}
