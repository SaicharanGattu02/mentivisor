import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/ProductTools/TaskUpdate/task_update_states.dart';
import '../product_tools_repository.dart';

class TaskUpdateCubit extends Cubit<TaskUpdateStates> {
  final ProductToolsRepository _productToolsRepository;

  TaskUpdateCubit(this._productToolsRepository) : super(TaskUpdateInitial());

  Future<void> updateTaskStatus(int taskId) async {
    emit(TaskUpdateLoading());
    try {
      final res = await _productToolsRepository.taskUpdate(taskId);
      if (res != null && res.status == true) {
        emit(TaskUpdateSuccess(successModel: res));
      } else {
        emit(
          TaskUpdateFailure(
            msg: "${res?.message ?? ""}.Failed to update task status.",
          ),
        );
      }
    } catch (e) {
      emit(TaskUpdateFailure(msg: "An error occurred: $e"));
    }
  }

  Future<void> deleteTask(int taskId) async {
    emit(TaskUpdateLoading());
    try {
      final res = await _productToolsRepository.taskDelete(taskId);
      if (res != null && res.status == true) {
        emit(TaskUpdateSuccess(successModel: res));
      } else {
        emit(
          TaskUpdateFailure(
            msg: "${res?.message ?? ""}.Failed to delete task status.",
          ),
        );
      }
    } catch (e) {
      emit(TaskUpdateFailure(msg: "An error occurred: $e"));
    }
  }

  Future<void> addTask(final Map<String, dynamic> data) async {
    emit(TaskUpdateLoading());
    try {
      final res = await _productToolsRepository.addTask(data);
      if (res != null && res.status == true) {
        emit(TaskUpdateSuccess(successModel: res));
      } else {
        emit(TaskUpdateFailure(msg: "${res?.message ?? ""}.Failed to add task status.",));
      }
    } catch (e) {
      emit(TaskUpdateFailure(msg: "An error occurred: $e"));
    }
  }
}
