
import '../../../Models/MenteeModels/CompusMentorListModel.dart';
import '../../../services/remote_data_source.dart';

abstract class CampusMentorListRepository {
  Future<CompusMentorListModel?> getCampusMentorList(String name,String scope);
}

class CampusMentorListRepositoryImpl implements CampusMentorListRepository {
  final RemoteDataSource remoteDataSource;

  CampusMentorListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CompusMentorListModel?> getCampusMentorList(String name,String scope) async {
    return await remoteDataSource.getCampusMentorList(name,scope);
  }
}
