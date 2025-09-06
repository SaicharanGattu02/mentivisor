import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class SessionCompleteRepo {
  Future<SuccessModel?> sessionComplete(int sessionId);
}

class SessionCompleteImpl implements SessionCompleteRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  SessionCompleteImpl({required this.mentorRemoteDataSource});
  @override
  Future<SuccessModel?> sessionComplete(int sessionId) async {
    return await mentorRemoteDataSource.sessionCompleted(sessionId);
  }
}
