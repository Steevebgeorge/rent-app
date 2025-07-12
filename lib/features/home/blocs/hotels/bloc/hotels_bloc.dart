import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';
import 'package:rent_app/features/home/repository/service2.dart';

part 'hotels_event.dart';
part 'hotels_state.dart';

class HotelsBloc extends Bloc<HotelsEvent, HotelsState> {
  HotelsBloc() : super(HotelsInitial()) {
    on<FetchHotels>(_onFetchHotels);
  }

  Future<void> _onFetchHotels(
      FetchHotels event, Emitter<HotelsState> emit) async {
    try {
      emit(HotelLoading());
      final hotels = await LoadHotelRepository().fetchHotels();
      log('fetche hotel details');
      emit(HotelLoaded(loadedHotelData: hotels));
    } catch (e) {
      emit(HotelLoadedError(error: e.toString()));
    }
  }
}
