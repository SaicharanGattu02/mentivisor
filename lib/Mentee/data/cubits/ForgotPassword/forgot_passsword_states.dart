import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class ForgotPasswordStates {}

class ForgotPasswordInitially extends ForgotPasswordStates {}

class ForgotPasswordLoading extends ForgotPasswordStates {}
class VerifyPasswordLoading extends ForgotPasswordStates {}

class ForgotPasswordSuccess extends ForgotPasswordStates {
  SuccessModel successModel;
  ForgotPasswordSuccess(this.successModel);
}
class VerifyPasswordSuccess extends ForgotPasswordStates {
  SuccessModel successModel;
  VerifyPasswordSuccess(this.successModel);
}

class ForgotPasswordFailure extends ForgotPasswordStates {
  String error;
  ForgotPasswordFailure(this.error);
}
