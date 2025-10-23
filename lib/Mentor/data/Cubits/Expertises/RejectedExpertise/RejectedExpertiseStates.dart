import '../../../../Models/ExpertisesModel.dart';

abstract class RejectedExpertiseState {}

class RejectedExpertiseInitial extends RejectedExpertiseState {}

class RejectedExpertiseLoading extends RejectedExpertiseState {}

class RejectedExpertiseLoaded extends RejectedExpertiseState {
  final ExpertisesModel model;

  RejectedExpertiseLoaded(this.model);
}

class RejectedExpertiseFailure extends RejectedExpertiseState {
  final String message;

  RejectedExpertiseFailure(this.message);
}
