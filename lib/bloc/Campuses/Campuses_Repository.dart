import '../../Models/GetCompusModel.dart';
import '../../services/remote_data_source.dart';

abstract class CampusRepo {
  Future<GetCompusModel?> getCampusApi();
}

class CampusesImpl implements CampusRepo {
  final RemoteDataSource remoteDataSource;

  CampusesImpl({required this.remoteDataSource});

  @override
  Future<GetCompusModel?> getCampusApi() async {
    return await remoteDataSource.getCampuses();
  }
}
