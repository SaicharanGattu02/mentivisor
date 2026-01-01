import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Models/CompusMentorListModel.dart';
import 'campus_mentor_list_repo.dart';
import 'campus_mentor_list_state.dart';

class CampusMentorListCubit extends Cubit<CampusMentorListState> {
  final CampusMentorListRepository campusMentorListRepository;

  CampusMentorListCubit(this.campusMentorListRepository)
    : super(CampusMentorListStateInitial());

  // Pagination properties
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  // This will hold the full list of campus mentors.
  CompusMentorListModel campusMentorListModel = CompusMentorListModel();

  Future<void> fetchCampusMentorList(String scope, String search) async {
    emit(CampusMentorListStateLoading());
    _currentPage = 1; // Reset to the first page when new search is initiated
    try {
      final result = await campusMentorListRepository.getCampusMentorList(
        scope,
        search,
        _currentPage,
      );
      if (result != null && result.status == true) {
        campusMentorListModel = result;
        _hasNextPage = result.data?.nextPageUrl != null;
        emit(CampusMentorListStateLoaded(result, _hasNextPage));
      } else {
        emit(CampusMentorListStateFailure(msg: "No data found."));
      }
    } catch (e) {
      emit(CampusMentorListStateFailure(msg: "An error occurred: $e"));
    }
  }

  Future<void> fetchMoreCampusMentors(String scope, String search) async {
    if (_isLoadingMore || !_hasNextPage) return; // Avoid multiple requests
    _isLoadingMore = true;
    _currentPage++; // Move to the next page
    emit(CampusMentorListStateLoadingMore(campusMentorListModel, _hasNextPage));

    try {
      final newData = await campusMentorListRepository.getCampusMentorList(
        scope,
        search,
        _currentPage,
      );
      if (newData != null && newData.status == true) {
        final combinedList = List<MentorsList>.from(
          campusMentorListModel.data?.mentors_list ?? [],
        )..addAll(newData.data!.mentors_list!);

        final updatedData = Data(
          currentPage: newData.data?.currentPage,
          mentors_list: combinedList,
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

        campusMentorListModel = CompusMentorListModel(
          status: newData.status,
          data: updatedData,
        );
        _hasNextPage = newData.data?.nextPageUrl != null;
        emit(CampusMentorListStateLoaded(campusMentorListModel, _hasNextPage));
      }
    } catch (e) {
      emit(CampusMentorListStateFailure(msg: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}
