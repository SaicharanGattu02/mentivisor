import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Models/StudyZoneCampusModel.dart';
import 'StudyZoneCampusRepository.dart';
import 'StudyZoneCampusState.dart';

class StudyZoneCampusCubit extends Cubit<StudyZoneCampusState> {
  final StudyZoneCampusRepository studyZoneCampusRepository;

  StudyZoneCampusCubit(this.studyZoneCampusRepository)
    : super(StudyZoneCampusInitial());

  StudyZoneCampusModel studyZoneCampusModel = StudyZoneCampusModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  Future<void> fetchStudyZoneCampus({String? scope, String? tag}) async {
    emit(StudyZoneCampusLoading());
    _currentPage = 1;
    try {
      final campusData = await studyZoneCampusRepository.getStudyZoneCampus(
        scope: scope,
        tag: tag,
        page: _currentPage,
      );
      if (campusData != null && campusData.status == true) {
        studyZoneCampusModel = campusData;
        _hasNextPage = campusData.studyZoneData?.nextPageUrl != null;
        emit(StudyZoneCampusLoaded(studyZoneCampusModel, _hasNextPage));
      } else {
        emit(
          StudyZoneCampusFailure(message: 'Failed to load study zone campus.'),
        );
      }
    } catch (e) {
      emit(StudyZoneCampusFailure(message: 'An error occurred: $e'));
    }
  }

  Future<void> fetchMoreStudyZoneCampus({String? scope, String? tag}) async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;
    emit(StudyZoneCampusLoadingMore(studyZoneCampusModel, _hasNextPage));
    try {
      final newData = await studyZoneCampusRepository.getStudyZoneCampus(
        scope: scope,
        tag: tag,
        page: _currentPage,
      );
      if (newData != null && newData.studyZoneData?.studyZoneCampusData?.isNotEmpty == true) {
        final combinedList = List<StudyZoneCampusData>.from(
          studyZoneCampusModel.studyZoneData?.studyZoneCampusData ?? [],
        )..addAll(newData.studyZoneData!.studyZoneCampusData!);

        final updatedData = StudyZoneData(
          currentPage: newData.studyZoneData?.currentPage,
          studyZoneCampusData: combinedList,
          firstPageUrl: newData.studyZoneData?.firstPageUrl,
          from: newData.studyZoneData?.from,
          lastPage: newData.studyZoneData?.lastPage,
          lastPageUrl: newData.studyZoneData?.lastPageUrl,
          links: newData.studyZoneData?.links,
          nextPageUrl: newData.studyZoneData?.nextPageUrl,
          path: newData.studyZoneData?.path,
          perPage: newData.studyZoneData?.perPage,
          prevPageUrl: newData.studyZoneData?.prevPageUrl,
          to: newData.studyZoneData?.to,
          total: newData.studyZoneData?.total,
        );

        studyZoneCampusModel = StudyZoneCampusModel(
          status: newData.status,
          studyZoneData: updatedData,
        );

        _hasNextPage = newData.studyZoneData?.nextPageUrl != null;
        emit(StudyZoneCampusLoaded(studyZoneCampusModel, _hasNextPage));
      }
    } catch (e) {
      emit(StudyZoneCampusFailure(message: 'An error occurred: $e'));
    } finally {
      _isLoadingMore = false;
    }
  }
}
