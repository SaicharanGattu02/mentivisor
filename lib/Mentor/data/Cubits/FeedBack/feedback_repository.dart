import 'package:mentivisor/Mentor/Models/FeedbackModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class FeedBackRepository {
  Future<FeedbackModel?> getFeedback(String user_id,List<int>stars,String time);
}

class FeedBackRepositoryImpl implements FeedBackRepository {
  MentorRemoteDataSource mentorRemoteDataSource;
  FeedBackRepositoryImpl({required this.mentorRemoteDataSource});
  @override
  Future<FeedbackModel?> getFeedback(String user_id,List<int>stars,String time) async {
    return await mentorRemoteDataSource.getFeedback(user_id,stars,time);
  }
}
