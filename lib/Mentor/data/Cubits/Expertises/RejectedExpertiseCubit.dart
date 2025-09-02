import 'package:flutter_bloc/flutter_bloc.dart';
import 'ExpertiseRepo.dart';
import 'ExpertiseState.dart';

class RejectedExpertiseCubit extends Cubit<ExpertiseState> {
  final ExpertisesRepo repo;
  RejectedExpertiseCubit(this.repo) : super(ExpertiseLoading());

  Future<void> fetch() async {
    emit(ExpertiseLoading());
    try {
      final model = await repo.fetchRejected();
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
