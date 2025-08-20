
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/Models/MentorProfileModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';


abstract class MentorProfileRepo1 {
  Future<MentorprofileModel?> getMentorProfile();
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data);
}

class MentorProfile1Impl implements MentorProfileRepo1 {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorProfile1Impl({required this.mentorRemoteDataSource});
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
