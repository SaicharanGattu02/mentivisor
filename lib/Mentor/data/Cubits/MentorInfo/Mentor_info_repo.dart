import 'package:mentivisor/Mentor/Models/MentorinfoResponseModel.dart';

import '../../MentorRemoteDataSource.dart';

abstract class MentorInfoRepo {
  Future<MentorinfoResponseModel?> getMentorinfo();
}

class MentorProfileRepoImpl implements MentorInfoRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorProfileRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<MentorinfoResponseModel?> getMentorinfo() async {
    return await mentorRemoteDataSource.mentorinfo();
  }
}
