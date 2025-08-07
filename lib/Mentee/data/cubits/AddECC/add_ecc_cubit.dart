import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/AddECC/add_ecc_states.dart';
import 'package:mentivisor/Mentee/data/cubits/ECC/ecc_repository.dart';

class AddEccCubit extends Cubit<AddEccStates> {
  ECCRepository eccRepository;
  AddEccCubit(this.eccRepository) : super(AddEccInitially());

  Future<void> addEcc(Map<String, dynamic> data) async {
    emit(AddEccLoading());
    try {
      final response = await eccRepository.addEcc(data);
      if (response != null) {
        emit(AddEccLoaded(response));
      } else {
        emit(AddEccFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(AddEccFailure(e.toString()));
    }
  }
}
