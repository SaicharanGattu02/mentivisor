import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import '../../../Models/ProductToolTaskByDateModel.dart';
import '../../../Models/TaskStatesModel.dart';
import '../../remote_data_source.dart';

abstract class ProductToolsRepository {
  Future<TaskStatesModel?> getTaskStates();
  Future<ProductToolTaskByDateModel?> getTaskByDates(String date);
  Future<SuccessModel?> taskUpdate(int taskId);
  Future<SuccessModel?> taskDelete(int taskId);
  Future<SuccessModel?> addTask(final Map<String, dynamic> data);
}

class ProductToolsImpl implements ProductToolsRepository {
  final RemoteDataSource remoteDataSource;

  ProductToolsImpl({required this.remoteDataSource});

  @override
  Future<TaskStatesModel?> getTaskStates() async {
    return await remoteDataSource.getTaskByStates();
  }

  @override
  Future<ProductToolTaskByDateModel?> getTaskByDates(String date) async {
    return await remoteDataSource.getTaskByDate(date);
  }

  @override
  Future<SuccessModel?> taskUpdate(int taskId) async {
    return await remoteDataSource.putTaskComplete(taskId);
  }

  @override
  Future<SuccessModel?> taskDelete(int taskId) async {
    return await remoteDataSource.TaskDelete(taskId);
  }

  @override
  Future<SuccessModel?> addTask(final Map<String, dynamic> data) async {
    return await remoteDataSource.addTask(data);
  }
}
