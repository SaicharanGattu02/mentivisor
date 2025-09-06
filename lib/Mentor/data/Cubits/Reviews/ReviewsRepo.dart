import '../../../Models/ReviewsModel.dart';
import '../../MentorRemoteDataSource.dart';

abstract class ReviewsRepo {
  Future<ReviewsModel?> getReviews(int page,String userId,List<int> stars,
      String time,);
}

class ReviewsRepoImpl implements ReviewsRepo {
  MentorRemoteDataSource mentorRemoteDataSource;

  ReviewsRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<ReviewsModel?> getReviews(int page, String userId,List<int> stars,
      String time,) async {
    return await mentorRemoteDataSource.getReviews(page,userId,stars,time);
  }
}
