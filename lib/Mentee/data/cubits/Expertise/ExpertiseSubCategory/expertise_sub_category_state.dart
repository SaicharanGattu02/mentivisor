import '../../../../Models/GetExpertiseModel.dart';

abstract class ExpertiseSubCategoryStates {}

class ExpertiseSubCategoryInitial extends ExpertiseSubCategoryStates {}

class ExpertiseSubCategoryLoading extends ExpertiseSubCategoryStates {}

class ExpertiseSubCategoryLoaded extends ExpertiseSubCategoryStates {
  final GetExpertiseModel expertiseModel;

  ExpertiseSubCategoryLoaded(this.expertiseModel);
}

class ExpertiseSubCategoryFailure extends ExpertiseSubCategoryStates {
  final String error;

  ExpertiseSubCategoryFailure(this.error);
}
