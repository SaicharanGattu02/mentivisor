import '../../../Models/CompusMentorListModel.dart';
import '../../remote_data_source.dart';

abstract class CampusMentorListRepository {
  Future<CompusMentorListModel?> getCampusMentorList(String scope, String search,int page);
}

class CampusMentorListRepositoryImpl implements CampusMentorListRepository {
  final RemoteDataSource remoteDataSource;

  CampusMentorListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CompusMentorListModel?> getCampusMentorList(  String scope, String search,int page) async {
    return await remoteDataSource.getCampusMentorList(scope,search,page);
  }
}
