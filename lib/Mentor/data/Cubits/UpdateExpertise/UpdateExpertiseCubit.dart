import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/ExpertiseRepo.dart';

import '../../../../Mentee/Models/SuccessModel.dart';
import '../../../Models/UpdateSubExpertiseModel.dart';
import 'UpdateExpertiseStates.dart';

class UpdateExpertiseCubit extends Cubit<UpdateExpertiseStates> {
  ExpertisesRepo expertisesRepo;
  UpdateExpertiseCubit(this.expertisesRepo) : super(UpdateExpertiseInitially());

  Future<UpdateSubExpertiseModel?> updateExpertise(Map<String, dynamic> data) async {
    emit(UpdateExpertiseLoading());
    try {
      final response = await expertisesRepo.updateExpertise(data);
      if (response != null && response.status == true) {
        emit(UpdateExpertiseLoaded(response));
        return response;
      } else {
        emit(UpdateExpertiseFailure("Update expertise failed!"));
      }
    } catch (e) {
      emit(UpdateExpertiseFailure(e.toString()));
    }
    return null;
  }
}
