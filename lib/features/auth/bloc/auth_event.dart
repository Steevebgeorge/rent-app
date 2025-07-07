// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  SignUpRequested({
    required this.email,
    required this.password,
    required this.userName,
  });
}

class LogOutRequeted extends AuthEvent {}
