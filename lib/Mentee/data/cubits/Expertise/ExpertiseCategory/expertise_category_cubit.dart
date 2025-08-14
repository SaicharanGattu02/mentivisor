import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Models/GetExpertiseModel.dart';
import '../expertise_repository.dart';
import 'expertise_category_state.dart';

class ExpertiseCategoryCubit extends Cubit<ExpertiseCategoryStates> {
  final ExpertiseRepo expertiseRepo;
  ExpertiseCategoryCubit(this.expertiseRepo)
    : super(ExpertiseCategoryInitial());

  GetExpertiseModel expertiseModel = GetExpertiseModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> getExpertiseCategories(String search) async {
    emit(ExpertiseCategoryLoading());
    _currentPage = 1;
    try {
      final response = await expertiseRepo.getExpertiseCategory(
        search,
        _currentPage,
      );

      if (response != null && response.status == true) {
        expertiseModel = response;
        _hasNextPage = response.data?.nextPageUrl != null;
        emit(ExpertiseCategoryLoaded(expertiseModel, _hasNextPage));
      } else {
        emit(ExpertiseCategoryFailure("Something went wrong"));
      }
    } catch (e) {
      emit(ExpertiseCategoryFailure(e.toString()));
    }
  }

  Future<void> fetchMoreExpertiseCategories(String search) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;
    emit(ExpertiseCategoryLoadingMore(expertiseModel, _hasNextPage));
    try {
      final newData = await expertiseRepo.getExpertiseCategory(
        search,
        _currentPage,
      );

      if (newData != null && newData.data?.data?.isNotEmpty == true) {
        final combinedList = List<ExpertiseData>.from(
          expertiseModel.data?.data ?? [],
        )..addAll(newData.data!.data!);

        final updatedData = ExpertisePagination(
          currentPage: newData.data?.currentPage,
          data: combinedList,
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
        );

        expertiseModel = GetExpertiseModel(
          status: newData.status,
          data: updatedData,
        );

        _hasNextPage = newData.data?.nextPageUrl != null;
        emit(ExpertiseCategoryLoaded(expertiseModel, _hasNextPage));
      }
    } catch (e) {
      emit(ExpertiseCategoryFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}
