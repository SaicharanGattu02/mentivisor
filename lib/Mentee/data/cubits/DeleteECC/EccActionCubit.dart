import 'package:flutter_bloc/flutter_bloc.dart';

import '../ECC/ecc_repository.dart';
import 'EccActionStates.dart';

class EccActionCubit extends Cubit<EccActionStates> {
  final ECCRepository eccRepository;

  EccActionCubit(this.eccRepository) : super(EccActionInitial());

  Future<void> eccAction(String id) async {
    emit(EccActionLoading());
    try {
      final response = await eccRepository.deleteECC(id);

      if (response != null && response.status == true) {
        emit(EccActionSuccess(response));
      } else {
        emit(EccActionFailure(response?.message ?? "Something went wrong"));
      }
    } catch (e) {
      emit(EccActionFailure(e.toString()));
    }
  }
}
