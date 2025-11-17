import '../../../Models/SuccessModel.dart';

abstract class DeletePostStates {}

class DeletePostInitial extends DeletePostStates {}

class DeletePostLoading extends DeletePostStates {}

class DeletePostSuccess extends DeletePostStates {
  final SuccessModel successModel;
  DeletePostSuccess(this.successModel);
}

class DeletePostFailure extends DeletePostStates {
  final String error;
  DeletePostFailure(this.error);
}
