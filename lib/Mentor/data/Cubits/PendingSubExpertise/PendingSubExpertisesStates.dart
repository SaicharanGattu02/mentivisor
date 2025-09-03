import '../../../Models/PendingSubExpertisesModel.dart';

abstract class PendingSubExpertisesStates {}

class PendingSubExpertisesInitially extends PendingSubExpertisesStates {}

class PendingSubExpertisesLoading extends PendingSubExpertisesStates {}

class PendingSubExpertisesLoaded extends PendingSubExpertisesStates {
  final PendingSubExpertisesModel pendingSubExpertisesModel;
  PendingSubExpertisesLoaded(this.pendingSubExpertisesModel);
}

class PendingSubExpertisesFailure extends PendingSubExpertisesStates {
  final String error;
  PendingSubExpertisesFailure(this.error);
}