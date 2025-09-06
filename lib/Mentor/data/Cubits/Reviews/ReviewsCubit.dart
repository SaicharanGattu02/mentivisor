import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/ReviewsModel.dart';
import 'ReviewsRepo.dart';
import 'ReviewsStates.dart';

class ReviewsCubit extends Cubit<ReviewsStates> {
  final ReviewsRepo reviewsRepo;

  ReviewsCubit(this.reviewsRepo) : super(ReviewsInitially());

  ReviewsModel reviewsModel = ReviewsModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> getReviews(String userId, List<int> stars, String time) async {
    emit(ReviewsLoading());
    _currentPage = 1;
    try {
      final response = await reviewsRepo.getReviews(
        _currentPage,
        userId,
        stars,
        time,
      );
      if (response != null && response.status == true) {
        reviewsModel = response;
        _hasNextPage = response.data?.nextPageUrl != null;
        emit(ReviewsLoaded(reviewsModel, _hasNextPage));
      } else {
        emit(ReviewsFailure(response?.message ?? "No data available"));
      }
    } catch (e) {
      emit(
        ReviewsFailure(
          "Error occurred while fetching reviews: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> getMoreReviews(
    String userid,
    List<int> stars,
    String time,
  ) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;
    emit(ReviewsLoadingMore(reviewsModel, _hasNextPage));
    try {
      final newData = await reviewsRepo.getReviews(
        _currentPage,
        userid,
        stars,
        time,
      );
      if (newData != null &&
          newData.data?.reviews != null &&
          newData.data!.reviews!.isNotEmpty) {
        final combinedList = List<Reviews>.from(
          reviewsModel.data?.reviews ?? [],
        )..addAll(newData.data!.reviews!);

        reviewsModel = ReviewsModel(
          status: newData.status,
          message: newData.message,
          data: Data(
            currentPage: newData.data?.currentPage,
            reviews: combinedList,
            firstPageUrl: newData.data?.firstPageUrl,
            from: newData.data?.from,
            lastPage: newData.data?.lastPage,
            lastPageUrl: newData.data?.lastPageUrl,
            links: newData.data?.links,
            nextPageUrl: newData.data?.nextPageUrl,
            path: newData.data?.path,
            perPage: newData.data?.perPage,
            prevPageUrl: newData.data?.prevPageUrl,
            to: newData.data?.to,
            total: newData.data?.total,
          ),
        );
        _hasNextPage = newData.data?.nextPageUrl != null;
        emit(ReviewsLoaded(reviewsModel, _hasNextPage));
      }
    } catch (e) {
      emit(
        ReviewsFailure(
          "Error occurred while fetching more reviews: ${e.toString()}",
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}
