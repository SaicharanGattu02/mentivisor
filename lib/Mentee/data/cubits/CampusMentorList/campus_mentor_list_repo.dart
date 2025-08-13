import '../../../Models/CompusMentorListModel.dart';
import '../../remote_data_source.dart';

abstract class CampusMentorListRepository {
  Future<CompusMentorListModel?> getCampusMentorList(String scope, String search,);
}

class CampusMentorListRepositoryImpl implements CampusMentorListRepository {
  final RemoteDataSource remoteDataSource;

  CampusMentorListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CompusMentorListModel?> getCampusMentorList(  String scope, String search,) async {
    return await remoteDataSource.getCampusMentorList(scope,search);
  }
}
