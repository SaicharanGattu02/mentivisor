import 'package:mentivisor/Mentee/Models/CommunityPostsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class CommunityPostsRepo {
  Future<CommunityPostsModel?> getCommunityPosts(int page);
}

class CommunityPostsRepoImpl implements CommunityPostsRepo {
  RemoteDataSource remoteDataSource;
  CommunityPostsRepoImpl({required this.remoteDataSource});

  Future<CommunityPostsModel?> getCommunityPosts(int page) async {
    return await remoteDataSource.getCommunityPosts(page);
  }
}
