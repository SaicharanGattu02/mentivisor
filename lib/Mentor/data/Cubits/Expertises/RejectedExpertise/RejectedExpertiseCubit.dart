import 'package:flutter_bloc/flutter_bloc.dart';

import '../ExpertiseRepo.dart';
import 'RejectedExpertiseStates.dart';

class RejectedExpertiseCubit extends Cubit<RejectedExpertiseState> {
  final ExpertisesRepo repo;

  RejectedExpertiseCubit(this.repo) : super(RejectedExpertiseInitial());

  Future<void> fetch() async {
    emit(RejectedExpertiseLoading());
    try {
      final model = await repo.fetchRejected();

      if (model != null && model.status == true) {
        emit(RejectedExpertiseLoaded(model));
      } else {
        emit(RejectedExpertiseFailure(model?.message ?? "Failed to fetch rejected expertises."));
      }
    } catch (e) {
      emit(RejectedExpertiseFailure("Error: ${e.toString()}"));
    }
  }
  void reset() {
    emit(RejectedExpertiseInitial());
  }
}
