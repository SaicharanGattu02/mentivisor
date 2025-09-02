import '../../../../Mentee/Models/SuccessModel.dart';

abstract class UpdateExpertiseStates {}

class UpdateExpertiseInitially extends UpdateExpertiseStates {}

class UpdateExpertiseLoading extends UpdateExpertiseStates {}

class UpdateExpertiseLoaded extends UpdateExpertiseStates {
  final SuccessModel successModel;
  UpdateExpertiseLoaded(this.successModel);
}

class UpdateExpertiseFailure extends UpdateExpertiseStates {
  final String error;
  UpdateExpertiseFailure(this.error);
}