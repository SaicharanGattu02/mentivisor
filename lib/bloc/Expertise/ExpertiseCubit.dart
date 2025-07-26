import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/Expertise/ExpertiseRepository.dart';
import 'package:mentivisor/bloc/Expertise/ExpertiseState.dart';

class Expertisecubit extends Cubit<Expertisestate> {
  Expertiserepository expertiserepository;

  Expertisecubit(this.expertiserepository) : super(expertiseStateIntially());

  Future<void> getexpertise() async {

    emit(expertiseStateLoading());
    try {
      final res = await expertiserepository.expertiseApi();
      if (res!= null&& res.status==true) {
        emit(expertiseStateLoaded(expertiseRespModel: res));
      } else {
        emit(expertiseStateFailure(msg: "No expertise found."));
      }
    } catch (e) {
      emit(expertiseStateFailure(msg: "An error occurred: $e"));
    }
  }

}