import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorInfo/Mentor_Info_states.dart';
import 'package:mentivisor/Mentor/data/Cubits/MentorInfo/Mentor_info_repo.dart';

import '../../../Models/MentorinfoResponseModel.dart';

class MentorInfoCubit extends Cubit<MentorInfoStates> {
  final MentorInfoRepo mentorProfileRepo;
  MentorInfoCubit(this.mentorProfileRepo) : super(MentorinfoInitially());

  MentorinfoResponseModel mentorinfoResponseModel =
  MentorinfoResponseModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  /// Initial load
  Future<void> getMentorinfo(String role) async {
    emit(MentorinfoLoading());
    _currentPage = 1;

    try {
      final response =
      await mentorProfileRepo.getMentorinfo(role, _currentPage);

      if (response != null && response.status == true) {
        mentorinfoResponseModel = response;
        _hasNextPage =
            response.info?.nextPageUrl != null;

        emit(MentorinfoLoaded(
          mentorinfoResponseModel,
          _hasNextPage,
        ));
      } else {
        emit(MentorinfoFailure(
            "Mentor Profile Details Loading Failed!"));
      }
    } catch (e) {
      emit(MentorinfoFailure(e.toString()));
    }
  }

  /// Pagination load
  Future<void> fetchMoreMentorinfo(String role) async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;

    emit(MentorinfoLoadingMore(
      mentorinfoResponseModel,
      _hasNextPage,
    ));

    try {
      final newData =
      await mentorProfileRepo.getMentorinfo(role, _currentPage);

      if (newData != null &&
          newData.info?.data?.isNotEmpty == true) {
        final combinedList = List<Data>.from(
            mentorinfoResponseModel.info?.data ?? [])
          ..addAll(newData.info!.data!);

        final updatedInfo = MentorInfo(
          currentPage: newData.info?.currentPage,
          data: combinedList,
          firstPageUrl: newData.info?.firstPageUrl,
          from: newData.info?.from,
          lastPage: newData.info?.lastPage,
          lastPageUrl: newData.info?.lastPageUrl,
          links: newData.info?.links,
          nextPageUrl: newData.info?.nextPageUrl,
          path: newData.info?.path,
          perPage: newData.info?.perPage,
          prevPageUrl: newData.info?.prevPageUrl,
          to: newData.info?.to,
          total: newData.info?.total,
        );

        mentorinfoResponseModel = MentorinfoResponseModel(
          status: newData.status,
          info: updatedInfo,
        );

        _hasNextPage =
            newData.info?.nextPageUrl != null;

        emit(MentorinfoLoaded(
          mentorinfoResponseModel,
          _hasNextPage,
        ));
      }
    } catch (e) {
      emit(MentorinfoFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}

