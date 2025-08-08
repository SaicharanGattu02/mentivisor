import '../../../../Models/TaskStatesModel.dart';

abstract class TaskByStatusStates {}

class TaskByStatusIntially extends TaskByStatusStates {}

class TaskByStatusLoading extends TaskByStatusStates {}

class TaskByStatusLoaded extends TaskByStatusStates {
  TaskStatesModel taskStatesModel;
  TaskByStatusLoaded({required this.taskStatesModel});
}

class TaskByStatusFailure extends TaskByStatusStates {
  final String msg;
  TaskByStatusFailure({required this.msg});
}
