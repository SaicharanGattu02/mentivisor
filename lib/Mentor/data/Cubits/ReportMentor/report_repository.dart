import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class ReportMentorRepository {
  Future<SuccessModel?> mentorReport(Map<String, dynamic> data);
}

class MentorReportImpl implements ReportMentorRepository {
  MentorRemoteDataSource mentorRemoteDataSource;
  MentorReportImpl({required this.mentorRemoteDataSource});
  @override
  Future<SuccessModel?> mentorReport(Map<String, dynamic> data) async {
    return await mentorRemoteDataSource.mentorReport(data);
  }
}
