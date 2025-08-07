import 'package:mentivisor/Mentee/Models/ECCModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class ECCRepository {
  Future<ECCModel?> getEcc(int page);
  Future<SuccessModel?> addEcc(Map<String, dynamic> data);
}

class ECCRepositoryImpl implements ECCRepository {
  RemoteDataSource remoteDataSource;
  ECCRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ECCModel?> getEcc(int page) async {
    return await remoteDataSource.getEcc(page);
  }

  @override
  Future<SuccessModel?> addEcc(Map<String, dynamic> data) async {
    return await remoteDataSource.addEcc(data);
  }
}
