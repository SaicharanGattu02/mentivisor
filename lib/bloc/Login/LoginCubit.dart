import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/bloc/Login/LoginRepository.dart';

import 'LoginState.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginrepository;

  LoginCubit(this.loginrepository) : super(LoginIntially());

  Future<void> logInApi(Map<String, dynamic> data) async {
    emit(LoginLoading());
    try {
      final res = await loginrepository.loginOtpApi(data);
      if (res != null && res.status == true) {
        emit(LoginSucess(logInModel: res));
      } else {
        emit(LoginFailure(message: res?.message ?? "Login failed"));
      }
    } catch (e) {
      emit(LoginFailure(message: "An error occurred: $e"));
    }
  }
}
