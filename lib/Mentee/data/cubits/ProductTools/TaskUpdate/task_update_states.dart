import 'package:mentivisor/Mentee/Models/SuccessModel.dart';

abstract class TaskUpdateStates {}

class TaskUpdateInitial extends TaskUpdateStates {}

class TaskUpdateLoading extends TaskUpdateStates {}

class TaskUpdateSuccess extends TaskUpdateStates {
  final SuccessModel successModel;
  TaskUpdateSuccess({required this.successModel});
}

class TaskUpdateFailure extends TaskUpdateStates {
  final String msg;
  TaskUpdateFailure({required this.msg});
}
