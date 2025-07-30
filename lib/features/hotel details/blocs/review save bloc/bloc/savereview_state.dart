part of 'savereview_bloc.dart';

sealed class SavereviewState {}

final class SavereviewInitial extends SavereviewState {}

final class SaveUserReviewLoading extends SavereviewState {}

final class SaveUserReviewSaved extends SavereviewState {}

final class SaveUserReviewError extends SavereviewState {
  final String error;

  SaveUserReviewError({required this.error});
}
