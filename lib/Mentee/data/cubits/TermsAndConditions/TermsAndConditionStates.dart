import '../../../Models/TermsAndCondition.dart';

abstract class TermsAndConditionStates {}

class TermsAndConditionInitial extends TermsAndConditionStates {}

class TermsAndConditionLoading extends TermsAndConditionStates {}

class TermsAndConditionLoaded extends TermsAndConditionStates {
  final TermsAndConditionModel termsAndConditionModel;

  TermsAndConditionLoaded(this.termsAndConditionModel);
}

class TermsAndConditionFailure extends TermsAndConditionStates {
  final String error;

  TermsAndConditionFailure(this.error);
}
