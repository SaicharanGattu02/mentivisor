import 'package:mentivisor/Mentor/Models/FeedbackModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class FeedBackRepository {
  Future<FeedbackModel?> getFeedback(String user_id);
}

class FeedBackRepositoryImpl implements FeedBackRepository {
  MentorRemoteDataSource mentorRemoteDataSource;
  FeedBackRepositoryImpl({required this.mentorRemoteDataSource});
  @override
  Future<FeedbackModel?> getFeedback(String user_id) async {
    return await mentorRemoteDataSource.getFeedback(user_id);
  }
}
