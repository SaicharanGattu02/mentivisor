import '../../../Models/MenteeModels/StudyZoneTagsModel.dart';
import '../../../services/remote_data_source.dart';

abstract class StudyZoneTagsRepository {
  Future<StudyZoneTagsModel?> getStudyZoneTags();
}

class StudyZoneTagsRepositoryImpl implements StudyZoneTagsRepository {
  final RemoteDataSource remoteDataSource;
  StudyZoneTagsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StudyZoneTagsModel?> getStudyZoneTags() async {
   return await remoteDataSource.getStudyZoneTags();
  }
}
