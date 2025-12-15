import 'package:mentivisor/Mentor/Models/MentorinfoResponseModel.dart';

import '../../MentorRemoteDataSource.dart';

abstract class MentorInfoRepo {
  Future<MentorinfoResponseModel?> getMentorinfo(String role,int page);
}

class MentorProfileRepoImpl implements MentorInfoRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorProfileRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<MentorinfoResponseModel?> getMentorinfo(String role,page) async {
    return await mentorRemoteDataSource.mentorinfo(role,page);
  }
}
