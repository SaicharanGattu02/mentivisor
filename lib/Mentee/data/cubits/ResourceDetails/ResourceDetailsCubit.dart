import 'dart:developer' as AppLogger;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../StudyZoneCampus/StudyZoneCampusRepository.dart';
import 'ResourceDetailsState.dart';

class Resourcedetailscubit extends Cubit<ResourceDetailsState> {
  StudyZoneCampusRepository studyZoneCampusRepository;

  Resourcedetailscubit(this.studyZoneCampusRepository)
    : super(ResourceDetailsInitially());

  Future<void> resourceDetails(int resourceId, String scope) async {
    AppLogger.log('resourceId1::${resourceId}');
    emit(ResourceDetailsLoading());
    try {
      final res = await studyZoneCampusRepository.resourceDetails(
        resourceId,
        scope,
      );
      if (res != null && res.status == true) {
        emit(ResourceDetailsLoaded(resourceDetailsModel: res));
      } else {
        emit(ResourceDetailsFailure(message: res?.message ?? ""));
      }
    } catch (e) {
      emit(ResourceDetailsFailure(message: "An error occurred: $e"));
    }
  }
}
