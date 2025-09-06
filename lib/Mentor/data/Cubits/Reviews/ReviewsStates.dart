import '../../../Models/ReviewsModel.dart';

abstract class ReviewsStates {}

class ReviewsInitially extends ReviewsStates {}

class ReviewsLoading extends ReviewsStates {}

class ReviewsLoaded extends ReviewsStates {
  final ReviewsModel reviewsModel;
  final bool hasNextPage;

  ReviewsLoaded(this.reviewsModel, this.hasNextPage);
}

class ReviewsLoadingMore extends ReviewsStates {
  final ReviewsModel reviewsModel;
  final bool hasNextPage;

  ReviewsLoadingMore(this.reviewsModel, this.hasNextPage);
}

class ReviewsFailure extends ReviewsStates {
  final String error;

  ReviewsFailure(this.error);
}
