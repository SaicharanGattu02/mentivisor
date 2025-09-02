import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/ExpertiseRepo.dart';

import '../../../Models/NonAttachedExpertisesModel.dart';
import 'NonAttachedExpertisesStates.dart';

class NonAttachedExpertisesCubit extends Cubit<NonAttachedExpertisesStates> {
  ExpertisesRepo expertisesRepo;
  NonAttachedExpertisesCubit(this.expertisesRepo)
    : super(NonAttachedExpertisesInitially());

  Future<NonAttachedExpertisesModel?> getNonAttachedExpertises() async {
    emit(NonAttachedExpertisesLoading());
    try {
      final response = await expertisesRepo.getNonAttachedExpertises();
      if (response != null) {
        emit(NonAttachedExpertisesLoaded(response));
        return response;
      } else {
        emit(NonAttachedExpertisesFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(NonAttachedExpertisesFailure(e.toString()));
    }
    return null;
  }
}
