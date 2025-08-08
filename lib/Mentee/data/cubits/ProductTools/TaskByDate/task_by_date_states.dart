
import '../../../../Models/ProductToolTaskByDateModel.dart';

abstract class TaskBydateStates {
}

class TaskBydateIntially extends TaskBydateStates {
}

class TaskBydateLoading extends TaskBydateStates {
}

class TaskBydateLoaded extends TaskBydateStates {
  ProductToolTaskByDateModel productToolTaskByDateModel;
  TaskBydateLoaded({required this.productToolTaskByDateModel});
}

class TaskBydateFailure extends TaskBydateStates {
  final String msg;
  TaskBydateFailure ({required this.msg});
}