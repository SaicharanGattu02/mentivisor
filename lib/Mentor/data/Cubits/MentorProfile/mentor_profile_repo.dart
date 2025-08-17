import 'package:mentivisor/Mentee/Models/MentorProfileModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class MentorProfileRepo {
  Future<MentorProfileModel?> getMentorProfile();
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data);
}

class MentorProfileRepoImpl implements MentorProfileRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorProfileRepoImpl({required this.mentorRemoteDataSource});
  @override
  Future<MentorProfileModel?> getMentorProfile() async {
    return await mentorRemoteDataSource.getMentorProfile();
  }

  @override
  Future<SuccessModel?> updateMentorProfile(Map<String, dynamic> data) async{
    // TODO: implement updateMentorProfile
    throw UnimplementedError();
  }
}
