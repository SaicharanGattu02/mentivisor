import 'package:flutter_bloc/flutter_bloc.dart';

import '../ExpertiseRepo.dart';
import 'PendingExpertiseStates.dart';

class PendingExpertiseCubit extends Cubit<PendingExpertiseState> {
  final ExpertisesRepo repo;

  PendingExpertiseCubit(this.repo) : super(PendingExpertiseInitial());

  Future<void> fetch() async {
    emit(PendingExpertiseLoading());
    try {
      final model = await repo.fetchPending();

      if (model != null && model.status == true) {
        emit(PendingExpertiseLoaded(model));
      } else {
        emit(PendingExpertiseFailure(model?.message ?? "Failed to fetch pending expertises."));
      }
    } catch (e) {
      emit(PendingExpertiseFailure("Error: ${e.toString()}"));
    }
  }

  void reset() {
    emit(PendingExpertiseInitial());
  }
}
