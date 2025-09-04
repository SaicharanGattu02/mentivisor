import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/Payment/payment_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/Payment/payment_states.dart';

import 'forgot_passsword_repository.dart';
import 'forgot_passsword_states.dart';

class ForgotPassswordCubit extends Cubit<ForgotPasswordStates> {
  ForgotPassswordRepository forgotPassswordRepository;
  ForgotPassswordCubit(this.forgotPassswordRepository)
    : super(ForgotPasswordInitially());

  Future<void> forgotPassword(Map<String, dynamic> data) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await forgotPassswordRepository.forgotPassword(data);
      if (response != null && response.status == true) {
        emit(ForgotPasswordSuccess(response));
      } else {
        emit(ForgotPasswordFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  Future<void> verifyPassword(Map<String, dynamic> data) async {
    emit(VerifyPasswordLoading());
    try {
      final response = await forgotPassswordRepository.forgotVerify(data);
      if (response != null && response.status == true) {
        emit(VerifyPasswordSuccess(response));
      } else {
        emit(ForgotPasswordFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }

  Future<void> resetPassword(Map<String, dynamic> data) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await forgotPassswordRepository.resetPassword(data);
      if (response != null && response.status == true) {
        emit(ForgotPasswordSuccess(response));
      } else {
        emit(ForgotPasswordFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }
}
