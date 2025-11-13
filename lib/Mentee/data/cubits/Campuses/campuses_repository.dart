import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/CampusesModel.dart';

abstract class CampusesRepository {
  Future<CampusesModel?> getCampuses(int page);
}

class CampusesRepositoryImpl implements CampusesRepository {
  RemoteDataSource remoteDataSource;
  CampusesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CampusesModel?> getCampuses(int page) async {
    return await remoteDataSource.getCampuses(page);
  }
}
