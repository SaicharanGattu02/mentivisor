import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/Models/MyMenteesModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class MyMenteesRepo {
  Future<MyMenteesModel?> getMyMentees();
  Future<SuccessModel?> reportMentee(Map<String, dynamic> data);
}

class MyMenteesRepoImpl implements MyMenteesRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MyMenteesRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<MyMenteesModel?> getMyMentees() async {
    return await mentorRemoteDataSource.getMyMentees();
  }

  @override
  Future<SuccessModel?> reportMentee(Map<String, dynamic> data) {
    return await mentorRemoteDataSource.reportMentee(data);
  }
}
