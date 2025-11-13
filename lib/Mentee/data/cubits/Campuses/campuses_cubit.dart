import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Campuses/campuses_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Campuses/campuses_states.dart';

import '../../../Models/CampusesModel.dart';

class CampusesCubit extends Cubit<CampusesStates> {
  final CampusesRepository campusesRepository;

  CampusesCubit(this.campusesRepository) : super(CampusesInitially());

  CampusesModel campusesModel = CampusesModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  /// ============================
  /// INITIAL FETCH
  /// ============================
  Future<void> getCampuses() async {
    emit(CampusesLoading());

    _currentPage = 1;

    try {
      final response = await campusesRepository.getCampuses(_currentPage);

      if (response != null && response.status == true) {
        campusesModel = response;

        // pagination flag
        _hasNextPage = response.data?.nextPageUrl != null;

        emit(CampusesLoaded(response, _hasNextPage));
      } else {
        emit(CampusesFailure("Something went wrong"));
      }
    } catch (e) {
      emit(CampusesFailure(e.toString()));
    }
  }

  /// ============================
  /// LOAD MORE
  /// ============================
  Future<void> fetchMoreCampuses() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;

    emit(CampusesLoadingMore(campusesModel, _hasNextPage));

    try {
      final newData =
      await campusesRepository.getCampuses(_currentPage);

      if (newData != null &&
          newData.data?.campuses?.isNotEmpty == true) {

        // combine old + new
        final combinedList = List<CampusData>.from(
            campusesModel.data?.campuses ?? [])
          ..addAll(newData.data!.campuses!);

        // Build updated pagination data
        final updatedPagination = PaginationData(
          currentPage: newData.data?.currentPage,
          campuses: combinedList,
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

        campusesModel = CampusesModel(
          status: newData.status,
          data: updatedPagination,
        );

        // update next page flag
        _hasNextPage = newData.data?.nextPageUrl != null;

        emit(CampusesLoaded(campusesModel, _hasNextPage));
      }
    } catch (e) {
      emit(CampusesFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}


