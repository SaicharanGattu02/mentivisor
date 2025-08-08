import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class PostCommentRepository {
  Future<SuccessModel?> postComment(Map<String, dynamic> data);
}
class PostCommentRepositoryImpl implements PostCommentRepository{
  RemoteDataSource remoteDataSource;
  PostCommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> postComment(Map<String, dynamic> data) async{
    return await remoteDataSource.postComment(data);
  }
}