import 'package:flutter_bloc/flutter_bloc.dart';

import '../ExpertiseRepo.dart';
import 'ApprovedExpertiseState.dart';


class ApprovedExpertiseCubit extends Cubit<ApprovedExpertiseState> {
  final ExpertisesRepo repo;

  ApprovedExpertiseCubit(this.repo) : super(ApprovedExpertiseInitial());

  Future<void> fetch() async {
    emit(ApprovedExpertiseLoading());
    try {
      final model = await repo.fetchApproved();

      if (model != null && model.status == true) {
        emit(ApprovedExpertiseLoaded(model));
      } else {
        emit(ApprovedExpertiseFailure(model?.message ?? "Failed to fetch approved expertises."));
      }
    } catch (e) {
      emit(ApprovedExpertiseFailure("Error: ${e.toString()}"));
    }
  }

  void reset() {
    emit(ApprovedExpertiseInitial());
  }
}
