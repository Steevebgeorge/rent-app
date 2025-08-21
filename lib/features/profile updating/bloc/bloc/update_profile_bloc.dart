import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/profile%20updating/repository/update.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final ProfileUpdateRepository _profilerepository = ProfileUpdateRepository();

  UpdateProfileBloc() : super(UpdateProfileInitial()) {
    on<OnUpdatePress>(_updateProfile);
  }

  Future<void> _updateProfile(
      OnUpdatePress event, Emitter<UpdateProfileState> emit) async {
    emit(UpdateProfileLoading());
    try {
      final email = event.email.trim();
      final location = event.location.trim();
      final userName = event.userName.trim();

      if (email.isEmpty) {
        emit(UpdateProfileError(errorMessage: "Email cannot be empty"));
        return;
      }
      if (userName.isEmpty) {
        emit(UpdateProfileError(errorMessage: 'Username cannot be empty'));
        return;
      }
      if (location.isEmpty) {
        emit(UpdateProfileError(errorMessage: 'Location cannot be empty'));
        return;
      }

      await _profilerepository.updateDetails(
        email: email,
        username: userName,
        location: location,
      );

      emit(UpdateProfileSuccess());
    } catch (e) {
      emit(UpdateProfileError(errorMessage: e.toString()));
    }
  }
}
