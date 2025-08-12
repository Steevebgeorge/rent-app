import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/auth/models/usermodel.dart';
import 'package:rent_app/common/repository/services.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUserData>(_loadUserData);
  }

  Future<void> _loadUserData(
      LoadUserData event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final user = await LoadUserRepository().loadUserData();
    if (user != null) {
      emit(UserLoaded(user: user));
    } else {
      emit(UserLoadError(error: 'error loading user data'));
    }
  }
}
