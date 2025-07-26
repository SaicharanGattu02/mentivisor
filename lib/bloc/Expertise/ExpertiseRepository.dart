import '../../Models/ExpertiseRespModel.dart';
import '../../services/remote_data_source.dart';

abstract class Expertiserepository {
  Future<ExpertiseRespModel?> expertiseApi();
}

class ExperticeImpl implements Expertiserepository {
  final RemoteDataSource remoteDataSource;

  ExperticeImpl({required this.remoteDataSource});

  @override
  Future<ExpertiseRespModel?> expertiseApi() async {
    return await remoteDataSource.getexpertise();
  }
}