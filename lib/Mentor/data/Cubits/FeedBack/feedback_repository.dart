import 'package:mentivisor/Mentor/Models/FeedbackModel.dart';
import 'package:mentivisor/Mentor/data/MentorRemoteDataSource.dart';

abstract class FeedBackRepository {
  Future<FeedbackModel?> getFeedback(int user_id,List<int> stars,int page,);
}

class FeedBackRepositoryImpl implements FeedBackRepository {
  MentorRemoteDataSource mentorRemoteDataSource;
  FeedBackRepositoryImpl({required this.mentorRemoteDataSource});
  @override
  Future<FeedbackModel?> getFeedback(int user_id,List<int> stars,int page,) async {
    return await mentorRemoteDataSource.getFeedback(user_id,stars,page);
  }
}
