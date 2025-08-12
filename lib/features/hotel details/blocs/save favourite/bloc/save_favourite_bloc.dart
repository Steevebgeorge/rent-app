import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/hotel%20details/repository/save_favourite.dart';

part 'save_favourite_event.dart';
part 'save_favourite_state.dart';

class SaveFavouriteBloc extends Bloc<SaveFavouriteEvent, SaveFavouriteState> {
  SaveFavouriteBloc() : super(SaveFavouriteInitial()) {
    on<AddFavouriteEvent>(_onAddFavourite);
    on<RemoveFavouriteEvent>(_onRemoveFavourite);
    on<LoadFavouritesEvent>(_onLoadFavourites);
  }

  Future<void> _onAddFavourite(
      AddFavouriteEvent event, Emitter<SaveFavouriteState> emit) async {
    emit(SaveFavouriteLoading());
    try {
      await SaveFavouriteRepository().saveFavourite(event.hotelId);
      final favourites = await SaveFavouriteRepository().getUserFavourites();
      emit(SaveFavouriteSuccess(favourites)); // ✅ Update UI
    } catch (e) {
      log('error in save favourite bloc: $e');
      emit(SaveFavouriteFailure(e.toString()));
    }
  }

  Future<void> _onRemoveFavourite(
      RemoveFavouriteEvent event, Emitter<SaveFavouriteState> emit) async {
    emit(SaveFavouriteLoading());
    try {
      await SaveFavouriteRepository().removeFavourite(event.hotelId);
      final favourites = await SaveFavouriteRepository().getUserFavourites();
      emit(SaveFavouriteSuccess(favourites)); // ✅ Update UI
    } catch (e) {
      emit(SaveFavouriteFailure(e.toString()));
    }
  }

  Future<void> _onLoadFavourites(
      LoadFavouritesEvent event, Emitter<SaveFavouriteState> emit) async {
    emit(SaveFavouriteLoading());
    try {
      final favourites = await SaveFavouriteRepository().getUserFavourites();
      emit(SaveFavouriteSuccess(favourites));
    } catch (e) {
      emit(SaveFavouriteFailure(e.toString()));
    }
  }
}
