import '../../../../Mentee/Models/SuccessModel.dart';
import '../../../Models/UpdateSubExpertiseModel.dart';

abstract class UpdateExpertiseStates {}

class UpdateExpertiseInitially extends UpdateExpertiseStates {}

class UpdateExpertiseLoading extends UpdateExpertiseStates {}

class UpdateExpertiseLoaded extends UpdateExpertiseStates {
  final UpdateSubExpertiseModel updateSubExpertiseModel;
  UpdateExpertiseLoaded(this.updateSubExpertiseModel);
}

class UpdateExpertiseFailure extends UpdateExpertiseStates {
  final String error;
  UpdateExpertiseFailure(this.error);
}