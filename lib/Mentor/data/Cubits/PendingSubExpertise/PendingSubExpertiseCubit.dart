import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Models/PendingSubExpertisesModel.dart';
import '../Expertises/ExpertiseRepo.dart';
import 'PendingSubExpertisesStates.dart';

class PendingSubExpertisesCubit extends Cubit<PendingSubExpertisesStates> {
  ExpertisesRepo expertisesRepo;

  PendingSubExpertisesCubit(this.expertisesRepo)
    : super(PendingSubExpertisesInitially());

  Future<PendingSubExpertisesModel?> getPendingSubExpertises(
    int id,
    String status,
  ) async {
    emit(PendingSubExpertisesLoading());
    try {
      final response = await expertisesRepo.getPendingSubExpertises(id, status);
      if (response != null) {
        emit(PendingSubExpertisesLoaded(response));
        return response;
      } else {
        emit(
          PendingSubExpertisesFailure("Pending sub-expertises loading failed!"),
        );
      }
    } catch (e) {
      emit(PendingSubExpertisesFailure(e.toString()));
    }
    return null;
  }
}
