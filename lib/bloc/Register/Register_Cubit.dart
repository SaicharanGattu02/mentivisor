import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/Register/Registor_State.dart';

import 'Register_Repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository registerRepository;

  RegisterCubit( this.registerRepository) : super(RegisterIntially());

  Future<void> registerApi(Map<String, dynamic> data) async {
    emit(RegisterLoading());
    try {
      final res = await registerRepository.RegisterApi(data);
      if (res != null && res.status == true) {
        emit(RegisterSucess(registerModel: res));
      } else {
        emit(RegisterFailure(message: res?.message ?? "Unknown error"));
      }
    } catch (e) {
      emit(RegisterFailure(message: "An error occurred: $e"));
    }
  }
}