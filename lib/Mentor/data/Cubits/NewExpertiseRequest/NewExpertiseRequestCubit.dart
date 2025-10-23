import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentor/data/Cubits/Expertises/ExpertiseRepo.dart';

import '../../../../Mentee/Models/BecomeMentorSuccessModel.dart';
import '../../../../Mentee/Models/SuccessModel.dart';
import 'NewExpertiseRequestStates.dart';

class NewExpertiseRequestCubit extends Cubit<NewExpertiseRequestStates> {
  ExpertisesRepo expertisesRepo;
  NewExpertiseRequestCubit(this.expertisesRepo)
    : super(NewExpertiseRequestInitially());

  Future<BecomeMentorSuccessModel?> newExpertiseRequest(
    Map<String, dynamic> data,
  ) async {
    emit(NewExpertiseRequestLoading());
    try {
      final response = await expertisesRepo.newExpertiseRequest(data);
      if (response != null && response.status == true) {
        emit(NewExpertiseRequestLoaded(response));
      } else {
        emit(NewExpertiseRequestFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(NewExpertiseRequestFailure(e.toString()));
    }
    return null;
  }
}
