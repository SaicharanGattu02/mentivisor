import '../../../Models/StudyZoneTagsModel.dart';
import '../../../Models/UpComingSessionModel.dart';
import '../../remote_data_source.dart';

abstract class UpComingSessionRepository {
  Future<UpComingSessionModel?> getUpComingSessions();
}

class UpComingSessionImpl implements UpComingSessionRepository {
  final RemoteDataSource remoteDataSource;
  UpComingSessionImpl({required this.remoteDataSource});

  @override
  Future<UpComingSessionModel?> getUpComingSessions() async {
    return await remoteDataSource.upComingSessions();
  }
}
