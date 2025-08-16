import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_Repository.dart';

import 'ExclusiveServiceDetails_State.dart';

class ExclusiveservicedetailsCubit extends Cubit<ExclusiveservicedetailsState> {
  ExclusiveservicedetailsRepository exclusiveservicedetailsRepository;
  ExclusiveservicedetailsCubit(this.exclusiveservicedetailsRepository)
    : super(ExclusiveservicedetailsStateIntially());

  Future<void> getexclusivedetails(int id) async {
    emit(ExclusiveservicedetailsStateLoading());
    try {
      final response = await exclusiveservicedetailsRepository
          .exclusiveServiceDetails(id);
      if (response != null && response.status == true) {
        emit(
          ExclusiveservicedetailsStateLoaded(
            exclusiveservicedetailsModel: response,
          ),
        );
      } else {
        emit(ExclusiveservicedetailsFailure(msg: response?.message ?? ""));
      }
    } catch (e) {
      emit(ExclusiveservicedetailsFailure(msg: e.toString()));
    }
  }
}
