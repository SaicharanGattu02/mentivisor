import '../../../Models/SuccessModel.dart';
import '../../remote_data_source.dart';

abstract class DeleteCommentRepo {
  Future<SuccessModel?> deleteComment({
    required String commentId,
  });
}
class DeleteCommentRepoImpl implements DeleteCommentRepo {
  final RemoteDataSource remoteDataSource;

  DeleteCommentRepoImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> deleteComment({
    required String commentId,
  }) async {
    return await remoteDataSource.deleteComment(commentId: commentId);
  }
}
