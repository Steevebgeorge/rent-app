import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/hotel%20details/models/hotelreviewmodel.dart';
import 'package:rent_app/features/hotel%20details/repository/hotelreviewrepository.dart';

part 'hotelreviews_event.dart';
part 'hotelreviews_state.dart';

class HotelreviewsBloc extends Bloc<FetchHotelreviewsEvent, HotelreviewsState> {
  HotelreviewsBloc() : super(HotelreviewsInitial()) {
    on<FetchHotelreviews>(_onFetchHotelReviews);
  }

  Future<void> _onFetchHotelReviews(
      FetchHotelreviews event, Emitter<HotelreviewsState> emit) async {
    emit(HotelreviewsLoading());
    try {
      final reviews = await HotelReviewRepository().fetchReviews(event.hotelId);
      emit(HotelreviewsFetched(reviews: reviews));
    } catch (e) {
      emit(HotelreviewsLoadingError(error: e.toString()));
    }
  }
}
