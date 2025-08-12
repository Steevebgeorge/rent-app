part of 'user_bloc.dart';

sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final AppUser user;

  UserLoaded({required this.user});
}

final class UserLoadError extends UserState {
  final String error;

  UserLoadError({required this.error});
}
