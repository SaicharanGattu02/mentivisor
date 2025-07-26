import '../../Models/TopMentersResponseModel.dart';
import '../../services/remote_data_source.dart';

abstract class TopmentorsRepository {
  Future<Topmentersresponsemodel?> topmentors();
}

class BannersImpl implements TopmentorsRepository {
  final RemoteDataSource remoteDataSource;

  BannersImpl({required this.remoteDataSource});

  @override
  Future<Topmentersresponsemodel?> topmentors() async {
    return await remoteDataSource.topmentors();
  }
}