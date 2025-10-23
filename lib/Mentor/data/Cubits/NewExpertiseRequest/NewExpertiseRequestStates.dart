import '../../../Models/UpdateExpertiseModel.dart';

abstract class NewExpertiseRequestStates {}

class NewExpertiseRequestInitially extends NewExpertiseRequestStates {}

class NewExpertiseRequestLoading extends NewExpertiseRequestStates {}

class NewExpertiseRequestLoaded extends NewExpertiseRequestStates {
  final UpdateExpertiseModel updateExpertiseModel;
  NewExpertiseRequestLoaded(this.updateExpertiseModel);
}

class NewExpertiseRequestFailure extends NewExpertiseRequestStates {
  final String error;
  NewExpertiseRequestFailure(this.error);
}