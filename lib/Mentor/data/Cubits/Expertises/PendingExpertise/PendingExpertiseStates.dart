
import '../../../../Models/ExpertisesModel.dart';

abstract class PendingExpertiseState {}

class PendingExpertiseInitial extends PendingExpertiseState {}

class PendingExpertiseLoading extends PendingExpertiseState {}

class PendingExpertiseLoaded extends PendingExpertiseState {
  final ExpertisesModel model;
  PendingExpertiseLoaded(this.model);
}

class PendingExpertiseFailure extends PendingExpertiseState {
  final String message;
  PendingExpertiseFailure(this.message);
}
