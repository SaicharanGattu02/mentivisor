import '../../../Models/SuccessModel.dart';

abstract class EccActionStates {}

class EccActionInitial extends EccActionStates {}

class EccActionLoading extends EccActionStates {}

class EccActionSuccess extends EccActionStates {
  final SuccessModel successModel;
  EccActionSuccess(this.successModel);
}

class EccActionFailure extends EccActionStates {
  final String error;
  EccActionFailure(this.error);
}
