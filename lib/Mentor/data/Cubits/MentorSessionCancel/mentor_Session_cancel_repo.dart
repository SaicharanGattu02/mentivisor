import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentor/Models/MyMenteesModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class SessionCanceledRepo{
Future<SuccessModel?> cancleedsessions(Map<String, dynamic> data);

}

class SessionCanceledImpl implements SessionCanceledRepo {
  MentorRemoteDataSource mentorRemoteDataSource;
  SessionCanceledImpl({required this.mentorRemoteDataSource});

  @override
  Future<SuccessModel?> cancleedsessions(Map<String, dynamic> data) async {
    return await mentorRemoteDataSource.mentorSessionCanceled(data);
  }
}
