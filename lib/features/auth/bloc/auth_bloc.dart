import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/auth/data/repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequested>(_signUpRequested);
    on<LoginRequested>(_loginRequested);
    on<LogOutRequeted>(_logoutRequested);
  }

  Future<void> _signUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(Authloading());
    try {
      final email = event.email.trim();
      final password = event.password.trim();
      final userName = event.userName.trim();
      final location = event.location.trim();

      if (email.isEmpty) {
        emit(AuthFailure(error: 'Email cannot be empty'));
        return;
      }
      if (password.isEmpty) {
        emit(AuthFailure(error: 'Password cannot be empty'));
        return;
      }
      if (password.length < 6) {
        emit(AuthFailure(error: 'Password must be more than 6 characters'));
        return;
      }

      await _authRepository.signIn(email, password, userName, location);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _loginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(Authloading());
    try {
      final email = event.email.trim();
      final password = event.password.trim();

      if (email.isEmpty) {
        emit(AuthFailure(error: 'Email cannot be empty'));
        return;
      }
      if (password.isEmpty) {
        emit(AuthFailure(error: 'Password cannot be empty'));
        return;
      }
      if (password.length < 6) {
        emit(AuthFailure(error: 'Password must be more than 6 characters'));
        return;
      }

      await _authRepository.login(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _logoutRequested(
      LogOutRequeted event, Emitter<AuthState> emit) async {
    emit(Authloading());
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
