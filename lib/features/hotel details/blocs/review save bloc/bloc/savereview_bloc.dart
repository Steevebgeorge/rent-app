import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/hotel%20details/repository/savereview.dart';

part 'savereview_event.dart';
part 'savereview_state.dart';

class SavereviewBloc extends Bloc<SavereviewEvent, SavereviewState> {
  SavereviewBloc() : super(SavereviewInitial()) {
    on<SaveUserReview>(_onSaveUserReview);
  }

  Future<void> _onSaveUserReview(
      SaveUserReview event, Emitter<SavereviewState> emit) async {
    emit(SaveUserReviewLoading());
    try {
      final rating = event.rating;
      final userName = event.userName;
      final comment = event.review;
      final hotelId = event.hotelId;
      await SaveUserReviewRepository().saveReview(
          hotelId: hotelId,
          comment: comment,
          rating: rating,
          userName: userName);
      emit(SaveUserReviewSaved());
    } catch (e) {
      emit(SaveUserReviewError(error: e.toString()));
    }
  }
}
