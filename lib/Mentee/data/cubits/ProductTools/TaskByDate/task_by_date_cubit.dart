import 'package:flutter_bloc/flutter_bloc.dart';
import '../product_tools_repository.dart';
import 'task_by_date_states.dart';

class TaskByDateCubit extends Cubit<TaskBydateStates> {
  final ProductToolsRepository _productToolsRepository;

  TaskByDateCubit(this._productToolsRepository) : super(TaskBydateIntially());

  Future<void> fetchTasksByDate(String date) async {
    emit(TaskBydateLoading());
    try {
      final res = await _productToolsRepository.getTaskByDates(date);
      if (res != null&& res.status==true) {
        emit(TaskBydateLoaded(productToolTaskByDateModel: res));
      } else {
        emit(TaskBydateFailure(msg: "No tasks found for the selected date."));
      }
    } catch (e) {
      emit(TaskBydateFailure(msg: "An error occurred: $e"));
    }
  }
}
