part of 'save_favourite_bloc.dart';

sealed class SaveFavouriteState {}

final class SaveFavouriteInitial extends SaveFavouriteState {}

final class SaveFavouriteLoading extends SaveFavouriteState {}

final class SaveFavouriteSuccess extends SaveFavouriteState {
  final List<String> favourites;

  SaveFavouriteSuccess(this.favourites);
}

final class SaveFavouriteFailure extends SaveFavouriteState {
  final String error;

  SaveFavouriteFailure(this.error);
}
