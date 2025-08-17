import 'package:mentivisor/Mentor/Models/SessionsModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class SessionSRepo {
  Future<SessionsModel?> getSessions(String type);
}

class SessionSRepoImpl implements SessionSRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  SessionSRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<SessionsModel?> getSessions(String type) async {
    return await mentorRemoteDataSource.getSessions(type);
  }
}
