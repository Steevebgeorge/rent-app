part of 'save_favourite_bloc.dart';

abstract class SaveFavouriteEvent {}

class AddFavouriteEvent extends SaveFavouriteEvent {
  final String hotelId;
  AddFavouriteEvent(this.hotelId);
}

class RemoveFavouriteEvent extends SaveFavouriteEvent {
  final String hotelId;
  RemoveFavouriteEvent(this.hotelId);
}

class LoadFavouritesEvent extends SaveFavouriteEvent {}
