import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/ExpertiseRepo.dart';

import '../../../Models/NonAttachedExpertiseDetailsModel.dart';
import 'NonAttachedExpertiseDetailsStates.dart';

class NonAttachedExpertiseDetailsCubit
    extends Cubit<NonAttachedExpertiseDetailsStates> {
  ExpertisesRepo expertisesRepo;
  NonAttachedExpertiseDetailsCubit(this.expertisesRepo)
    : super(NonAttachedExpertiseDetailsInitially());

  Future<NonAttachedExpertiseDetailsModel?> getNonAttachedExpertiseDetails(
    int id,
  ) async {
    emit(NonAttachedExpertiseDetailsLoading());
    try {
      final response = await expertisesRepo.getNonAttachedExpertiseDetails(id);
      if (response != null) {
        emit(NonAttachedExpertiseDetailsLoaded(response));
        return response;
      } else {
        emit(NonAttachedExpertiseDetailsFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(NonAttachedExpertiseDetailsFailure(e.toString()));
    }
    return null;
  }
}
