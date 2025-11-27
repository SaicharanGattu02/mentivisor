import '../../../Models/SuccessModel.dart';

abstract class DeleteSlotStates {}

class DeleteSlotInitial extends DeleteSlotStates {}

class DeleteSlotLoading extends DeleteSlotStates {}

class DeleteSlotLoaded extends DeleteSlotStates {
  final SuccessModel successModel;

  DeleteSlotLoaded(this.successModel);
}

class DeleteSlotFailure extends DeleteSlotStates {
  final String error;

  DeleteSlotFailure(this.error);
}
