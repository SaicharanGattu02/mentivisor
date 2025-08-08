import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class AddResourceRepository {
  Future<SuccessModel?> addResource(Map<String, dynamic> data);
}

class AddResourceRepositoryImpl implements AddResourceRepository {
  RemoteDataSource remoteDataSource;
  AddResourceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> addResource(Map<String, dynamic> data) async {
    return await remoteDataSource.addResource(data);
  }
}
