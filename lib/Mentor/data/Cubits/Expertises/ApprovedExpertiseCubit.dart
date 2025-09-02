import 'package:flutter_bloc/flutter_bloc.dart';
import 'ExpertiseRepo.dart';
import 'ExpertiseState.dart';

class ApprovedExpertiseCubit extends Cubit<ExpertiseState> {
  final ExpertisesRepo repo;
  ApprovedExpertiseCubit(this.repo) : super(ExpertiseLoading());

  Future<void> fetch() async {
    emit(ExpertiseLoading());
    try {
      final model = await repo.fetchApproved();
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
