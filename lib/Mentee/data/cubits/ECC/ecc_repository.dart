import 'package:mentivisor/Mentee/Models/ECCModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class ECCRepository {
  Future<ECCModel?> getEcc(int page);
}

class ECCRepositoryImpl implements ECCRepository {
  RemoteDataSource remoteDataSource;
  ECCRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ECCModel?> getEcc(int page) async {
    return await remoteDataSource.getEcc(page);
  }
}
