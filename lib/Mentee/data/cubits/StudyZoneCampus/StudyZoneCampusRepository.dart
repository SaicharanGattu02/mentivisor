import '../../../Models/ResourceDetailsModel.dart';
import '../../../Models/StudyZoneCampusModel.dart';
import '../../remote_data_source.dart';

abstract class StudyZoneCampusRepository {
  Future<StudyZoneCampusModel?> getStudyZoneCampus(
    String scope,
    String tag,
    String search,
    int page,
  );
  Future<ResourceDetailsModel?> resourceDetails(int resourceId,String scope);
}

class StudyZoneCampusRepositoryImpl implements StudyZoneCampusRepository {
  RemoteDataSource remoteDataSource;

  StudyZoneCampusRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StudyZoneCampusModel?> getStudyZoneCampus(
    String scope,
    String tag,
    String search,
    int page,
  ) async {
    return await remoteDataSource.getStudyZoneCampus(scope, tag, search, page);
  }

  @override
  Future<ResourceDetailsModel?> resourceDetails(int resourceId,String scope) async {
    return await remoteDataSource.getResourceDetails(resourceId,scope);
  }
}
