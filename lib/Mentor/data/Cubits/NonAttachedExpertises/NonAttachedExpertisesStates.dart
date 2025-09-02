import '../../../Models/NonAttachedExpertisesModel.dart';

abstract class NonAttachedExpertisesStates {}

class NonAttachedExpertisesInitially extends NonAttachedExpertisesStates {}

class NonAttachedExpertisesLoading extends NonAttachedExpertisesStates {}

class NonAttachedExpertisesLoaded extends NonAttachedExpertisesStates {
  final NonAttachedExpertisesModel nonAttachedExpertisesModel;
  NonAttachedExpertisesLoaded(this.nonAttachedExpertisesModel);
}

class NonAttachedExpertisesFailure extends NonAttachedExpertisesStates {
  final String error;
  NonAttachedExpertisesFailure(this.error);
}