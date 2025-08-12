import '../../../Models/GetBannersRespModel.dart';
import '../../remote_data_source.dart';

abstract class Getbannersrepository {
  Future<GetBannersRespModel?> getBannersApi();
}

class BannersImpl implements Getbannersrepository {
  final RemoteDataSource remoteDataSource;
  BannersImpl({required this.remoteDataSource});
  @override
  Future<GetBannersRespModel?> getBannersApi() async {
    return await remoteDataSource.getbanners();
  }
}
