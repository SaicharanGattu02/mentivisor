import '../../../Models/SuccessModel.dart';

abstract class AddResourceStates {}

class AddResourceInitially extends AddResourceStates {}

class AddResourceLoading extends AddResourceStates {
  final String resourceId;
  AddResourceLoading(this.resourceId);
}

class AddResourceLoaded extends AddResourceStates {
  final SuccessModel successModel;
  final String resourceId;
  AddResourceLoaded(this.successModel, this.resourceId);
}
class AddResourceSuccess extends AddResourceStates {
  final SuccessModel successModel;
  final String resourceId;
  AddResourceSuccess(this.successModel, this.resourceId);
}

class AddResourceFailure extends AddResourceStates {
  final String error;
  final String resourceId;
  AddResourceFailure(this.error, this.resourceId);
}
