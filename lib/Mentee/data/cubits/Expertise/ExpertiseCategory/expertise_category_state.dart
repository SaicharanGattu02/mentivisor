import '../../../../Models/GetExpertiseModel.dart';

abstract class ExpertiseCategoryStates {}

class ExpertiseCategoryInitial extends ExpertiseCategoryStates {}

class ExpertiseCategoryLoading extends ExpertiseCategoryStates {}

class ExpertiseCategoryLoaded extends ExpertiseCategoryStates {
  final GetExpertiseModel expertiseModel;
  final bool hasNextPage;

  ExpertiseCategoryLoaded(this.expertiseModel, this.hasNextPage);
}

class ExpertiseCategoryLoadingMore extends ExpertiseCategoryStates {
  final GetExpertiseModel expertiseModel;
  final bool hasNextPage;

  ExpertiseCategoryLoadingMore(this.expertiseModel, this.hasNextPage);
}

class ExpertiseCategoryFailure extends ExpertiseCategoryStates {
  final String error;

  ExpertiseCategoryFailure(this.error);
}
