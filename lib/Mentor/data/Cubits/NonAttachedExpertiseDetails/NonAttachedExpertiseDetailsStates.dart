import '../../../Models/NonAttachedExpertiseDetailsModel.dart';

abstract class NonAttachedExpertiseDetailsStates {}

class NonAttachedExpertiseDetailsInitially extends NonAttachedExpertiseDetailsStates {}

class NonAttachedExpertiseDetailsLoading extends NonAttachedExpertiseDetailsStates {}

class NonAttachedExpertiseDetailsLoaded extends NonAttachedExpertiseDetailsStates {
  final NonAttachedExpertiseDetailsModel nonAttachedExpertiseDetailsModel;
  NonAttachedExpertiseDetailsLoaded(this.nonAttachedExpertiseDetailsModel);
}

class NonAttachedExpertiseDetailsFailure extends NonAttachedExpertiseDetailsStates {
  final String error;
  NonAttachedExpertiseDetailsFailure(this.error);
}