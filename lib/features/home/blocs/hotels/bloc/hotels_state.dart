part of 'hotels_bloc.dart';

sealed class HotelsState {}

final class HotelsInitial extends HotelsState {}

final class HotelLoading extends HotelsState {}

final class HotelLoaded extends HotelsState {
  final List<HotelModel> loadedHotelData;

  HotelLoaded({required this.loadedHotelData});
}

final class HotelLoadedError extends HotelsState {
  final String error;

  HotelLoadedError({required this.error});
}
