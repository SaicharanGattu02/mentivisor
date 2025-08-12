import 'package:flutter_bloc/flutter_bloc.dart';
import 'Verify_Otp_Repository.dart';
import 'Verify_Otp_State.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtpRepository _verifyOtpRepository;

  VerifyOtpCubit(this._verifyOtpRepository) : super(verifyotpIntially());

  Future<void> VerifyotpApi(Map<String, dynamic> data) async {
    emit(verifyotpLoading());
    try {
      final res = await _verifyOtpRepository.verifyotpApi(data);
      if (res != null && res.status == true) {
        emit(verifyotpSucess(res));
      } else {
        emit(verifyotpFailure(message: res?.message ?? "Unknown error"));
      }
    } catch (e) {
      emit(verifyotpFailure(message: "An error occurred: $e"));
    }
  }
}
