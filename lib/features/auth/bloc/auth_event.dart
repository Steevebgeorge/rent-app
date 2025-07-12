part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({
    required this.email,
    required this.password,
  });
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String userName;
  final String location;
  SignUpRequested({
    required this.email,
    required this.password,
    required this.userName,
    required this.location,
  });
}

class LogOutRequeted extends AuthEvent {}
