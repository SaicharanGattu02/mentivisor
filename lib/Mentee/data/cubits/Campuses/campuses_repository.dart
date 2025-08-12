import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/CampusesModel.dart';

abstract class CampusesRepository {
  Future<CampusesModel?> getCampuses();
}

class CampusesRepositoryImpl implements CampusesRepository {
  RemoteDataSource remoteDataSource;
  CampusesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CampusesModel?> getCampuses() async {
    return await remoteDataSource.getCampuses();
  }
}
