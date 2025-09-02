import '../../../../Mentee/Models/SuccessModel.dart';

abstract class NewExpertiseRequestStates {}

class NewExpertiseRequestInitially extends NewExpertiseRequestStates {}

class NewExpertiseRequestLoading extends NewExpertiseRequestStates {}

class NewExpertiseRequestLoaded extends NewExpertiseRequestStates {
  final SuccessModel successModel;
  NewExpertiseRequestLoaded(this.successModel);
}

class NewExpertiseRequestFailure extends NewExpertiseRequestStates {
  final String error;
  NewExpertiseRequestFailure(this.error);
}