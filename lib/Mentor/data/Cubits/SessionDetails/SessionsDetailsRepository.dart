import 'package:mentivisor/Mentor/Models/SessionsModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

import '../../../Models/SessionDetailsModel.dart';

abstract class SessionsDetailsRepo {
  Future<SessionDetailsModel?> getSessionsDetails(int sessionId);
}

class SessionsDetailsRepoImpl implements SessionsDetailsRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  SessionsDetailsRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<SessionDetailsModel?> getSessionsDetails(int sessionId) async {
    return await mentorRemoteDataSource.getSessionsDetails(sessionId);
  }
}
