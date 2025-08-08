import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/ProductTools/TaskByStates/task_by_states_states.dart';
import '../product_tools_repository.dart';

class TaskByStatusCubit extends Cubit<TaskByStatusStates> {
  final ProductToolsRepository _productToolsRepository;

  TaskByStatusCubit(this._productToolsRepository)
    : super(TaskByStatusIntially());

  Future<void> fetchTasksByStatus() async {
    emit(TaskByStatusLoading());
    try {
      final res = await _productToolsRepository.getTaskStates();
      if (res != null&& res.status==true) {
        emit(TaskByStatusLoaded(taskStatesModel: res));
      } else {
        emit(TaskByStatusFailure(msg: "No tasks found for status: $res."));
      }
    } catch (e) {
      emit(TaskByStatusFailure(msg: "An error occurred: $e"));
    }
  }
}
