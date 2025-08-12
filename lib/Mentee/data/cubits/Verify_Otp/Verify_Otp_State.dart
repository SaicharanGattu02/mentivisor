import 'package:equatable/equatable.dart';
import '../../../Models/OtpVerifyModel.dart';

abstract class VerifyOtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class verifyotpIntially extends VerifyOtpState {}

class verifyotpLoading extends VerifyOtpState {}

class verifyotpSucess extends VerifyOtpState {
  final Otpverifymodel otpverifymodel;
  verifyotpSucess(this.otpverifymodel);
}

class verifyotpFailure extends VerifyOtpState {
  final String message;
  verifyotpFailure({required this.message});
}
