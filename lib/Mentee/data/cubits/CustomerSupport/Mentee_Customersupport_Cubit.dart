import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/CustomerSupport/Mentee_Customersupport_Repo.dart';
import 'package:mentivisor/Mentee/data/cubits/CustomerSupport/Mentee_Customersupport_States.dart';

class MenteeCustomersupportCubit extends Cubit<MenteeCustomersupportStates> {
  MenteeCustomersupportRepo menteeCustomersupportRepo;
  MenteeCustomersupportCubit(this.menteeCustomersupportRepo)
    : super(MenteeCustomersupportIntially());

  Future<void> exclusiveServiceDetails(int id) async {
    emit(MenteeCustomersupportLoading());
    try {
      final response = await menteeCustomersupportRepo
          .getmenteecustomersupport();
      if (response != null && response.status == true) {
        emit(MenteeCustomersupportLoaded(response));
      } else {
        emit(MenteeCustomersupportFailure(msg: response?.msg ?? ""));
      }
    } catch (e) {
      emit(MenteeCustomersupportFailure(msg: e.toString()));
    }
  }
}
