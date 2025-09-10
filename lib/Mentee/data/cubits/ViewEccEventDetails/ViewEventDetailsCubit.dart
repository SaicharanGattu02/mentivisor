import 'dart:developer' as AppLogger;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../ECC/ecc_repository.dart';
import '../StudyZoneCampus/StudyZoneCampusRepository.dart';
import 'ViewEventDetailsState.dart';

class ViewEventDetailsCubit extends Cubit<ViewEventDetailsState> {
  ECCRepository eccRepository;

  ViewEventDetailsCubit(this.eccRepository)
    : super(ViewEventDetailsInitially());

  Future<void> eventDetails(int eventId) async {
    emit(ViewEventDetailsLoading());
    try {
      final res = await eccRepository.viewEccDetails(eventId);
      if (res != null && res.status == true) {
        emit(ViewEventDetailsLoaded(viewEccDetailsModel: res));
      } else {
        emit(ViewEventDetailsFailure(message: res?.message ?? ""));
      }
    } catch (e) {
      emit(ViewEventDetailsFailure(message: "An error occurred: $e"));
    }
  }
}
