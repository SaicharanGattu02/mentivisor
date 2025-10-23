
import '../../../../Models/ExpertisesModel.dart';

abstract class ApprovedExpertiseState {}

class ApprovedExpertiseInitial extends ApprovedExpertiseState {}

class ApprovedExpertiseLoading extends ApprovedExpertiseState {}

class ApprovedExpertiseLoaded extends ApprovedExpertiseState {
  final ExpertisesModel model;
  ApprovedExpertiseLoaded(this.model);
}

class ApprovedExpertiseFailure extends ApprovedExpertiseState {
  final String message;
  ApprovedExpertiseFailure(this.message);
}
