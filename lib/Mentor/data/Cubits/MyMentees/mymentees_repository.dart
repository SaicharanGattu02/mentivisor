import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/Models/MyMenteesModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class MyMenteesRepo {
  Future<MyMenteesModel?> getMyMentees(int page);
  Future<SuccessModel?> reportMentee(Map<String, dynamic> data);
}

class MyMenteesRepoImpl implements MyMenteesRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  MyMenteesRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<MyMenteesModel?> getMyMentees(int page) async {
    return await mentorRemoteDataSource.getMyMentees(page);
  }

  @override
  Future<SuccessModel?> reportMentee(Map<String, dynamic> data) async {
    return await mentorRemoteDataSource.reportMentee(data);
  }
}
