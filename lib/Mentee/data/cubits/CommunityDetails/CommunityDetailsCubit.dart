import 'dart:developer' as AppLogger;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../CommunityPosts/CommunityPostsRepository.dart';
import '../StudyZoneCampus/StudyZoneCampusRepository.dart';
import 'CommunityDetailsState.dart';

class CommunityDetailsCubit extends Cubit<CommunityDetailsState> {
  CommunityPostsRepo communityPostsRepo;

  CommunityDetailsCubit(this.communityPostsRepo)
    : super(CommunityDetailsInitially());

  Future<void> communityDetails(int communityId) async {
    emit(CommunityDetailsLoading());
    try {
      final res = await communityPostsRepo.communityDetails(
        communityId,
      );
      if (res != null && res.status == true) {
        emit(CommunityDetailsLoaded(communityDetailsModel: res));
      } else {
        emit(CommunityDetailsFailure(message: res?.message ?? ""));
      }
    } catch (e) {
      emit(CommunityDetailsFailure(message: "An error occurred: $e"));
    }
  }
}
