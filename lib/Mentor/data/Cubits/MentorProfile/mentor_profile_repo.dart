
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

import '../../../Models/MentorProfileModel.dart';

abstract class MentorProfileRepo {
  Future<MentorprofileModel?> getMentorProfile();
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data);
}

class MentorProfileRepoImpl implements MentorProfileRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorProfileRepoImpl({required this.mentorRemoteDataSource});
  @override
  Future<MentorprofileModel?> getMentorProfile() async {
    return await mentorRemoteDataSource.getMentorProfile();
  }

  @override
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data) async{
    // TODO: implement updateMentorProfile
    throw UnimplementedError();
  }
}
