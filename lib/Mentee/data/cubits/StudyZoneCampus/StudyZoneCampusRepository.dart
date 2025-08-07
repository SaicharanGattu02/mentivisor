import '../../../Models/StudyZoneCampusModel.dart';
import '../../remote_data_source.dart';

abstract class StudyZoneCampusRepository {
  Future<StudyZoneCampusModel?> getStudyZoneCampus(String scope, String tag);
}

class StudyZoneCampusRepositoryImpl implements StudyZoneCampusRepository {
  RemoteDataSource remoteDataSource;

  StudyZoneCampusRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StudyZoneCampusModel?> getStudyZoneCampus(
    String scope,
    String tag,
  ) async {
    return await remoteDataSource.getStudyZoneCampus(scope, tag);
  }
}
