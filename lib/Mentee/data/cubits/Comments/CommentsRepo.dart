import '../../../../Mentor/data/MentorRemoteDataSource.dart';
import '../../../Models/CommentsModel.dart';

abstract class CommentsRepo {
  Future<CommentsModel?> getComments(int entityId);
}

class CommentsRepoImpl implements CommentsRepo {
  final MentorRemoteDataSource mentorRemoteDataSource;
  CommentsRepoImpl({required this.mentorRemoteDataSource});

  @override
  Future<CommentsModel?> getComments(int entityId) async {
    return await mentorRemoteDataSource.getComments(entityId);
  }
}
