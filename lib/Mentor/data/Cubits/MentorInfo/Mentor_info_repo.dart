import 'package:mentivisor/Mentor/Models/MentorinfoResponseModel.dart';

import '../../MentorRemoteDataSource.dart';

abstract class MentorInfoRepo {
  Future<MentorinfoResponseModel?> getMentorinfo(String role);
}

class MentorProfileRepoImpl implements MentorInfoRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorProfileRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<MentorinfoResponseModel?> getMentorinfo(String role) async {
    return await mentorRemoteDataSource.mentorinfo(role);
  }
}
