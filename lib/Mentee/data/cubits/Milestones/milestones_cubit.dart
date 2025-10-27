import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Milestones/milestones_repo.dart';
import 'package:mentivisor/Mentee/data/cubits/Milestones/milestones_states.dart';

class MilestonesCubit extends Cubit<MilesStoneStates> {
  MilestonesRepo milestonesRepo;
  MilestonesCubit(this.milestonesRepo) : super(MilesStoneInitially());

  Future<void> getMilestones() async {
    emit(MilesStoneLoading());
    try {
      final response = await milestonesRepo.getMilestones();
      if (response != null && response.status == true) {
        emit(MilesStoneLoaded(response));
      } else {
        emit(MilesStoneFailure("Milestones Loading failed!"));
      }
    } catch (e) {
      emit(MilesStoneFailure("Milestones Loading failed throwing exception!"));
    }
  }
}
