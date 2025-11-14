import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/CampusesModel.dart';

abstract class CampusesRepository {
  Future<CampusesModel?> getCampuses(int page, String search);
}

class CampusesRepositoryImpl implements CampusesRepository {
  RemoteDataSource remoteDataSource;
  CampusesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CampusesModel?> getCampuses(int page,String search) async {
    return await remoteDataSource.getCampuses(page,search);
  }
}
