import 'package:flutter_bloc/flutter_bloc.dart';

import 'ExpertiseRepo.dart';
import 'ExpertiseState.dart';

class PendingExpertiseCubit extends Cubit<ExpertiseState> {
  final ExpertisesRepo repo;
  PendingExpertiseCubit(this.repo) : super(ExpertiseInitially());

  Future<void> fetch() async {
    emit(ExpertiseLoading());
    try {
      final model = await repo.fetchPending();
      if (model != null && model.status == true) {
        emit(ExpertiseLoaded(model));
      } else {
        emit(ExpertiseFailure(model?.message ?? ""));
      }
    } catch (e) {
      emit(ExpertiseFailure(e.toString()));
    }
  }
}