import 'package:mentivisor/Mentee/Models/CommunityPostsModel.dart';
import 'package:mentivisor/Mentee/Models/CommunityZoneTagsModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/CommunityDetailsModel.dart';

abstract class CommunityPostsRepo {
  Future<CommunityPostsModel?> getCommunityPosts(
    String scope,
    String post,
    int page,
  );
  Future<CommunityZoneTagsModel?> getCommunityZoneTags();
  Future<SuccessModel?> addCommunityPost(Map<String, dynamic> data);
  Future<SuccessModel?> communityZoneReport(Map<String, dynamic> data);
  Future<CommunityDetailsModel?> communityDetails(
    int communityId,
    String scope,
  );
  Future<SuccessModel?> deletePost(String id);
}

class CommunityPostsRepoImpl implements CommunityPostsRepo {
  RemoteDataSource remoteDataSource;
  CommunityPostsRepoImpl({required this.remoteDataSource});

  Future<CommunityPostsModel?> getCommunityPosts(
    String scope,
    String post,
    int page,
  ) async {
    return await remoteDataSource.getCommunityPosts(scope, post, page);
  }

  @override
  Future<CommunityZoneTagsModel?> getCommunityZoneTags() async {
    return await remoteDataSource.getCommunityZoneTags();
  }

  @override
  Future<SuccessModel?> addCommunityPost(Map<String, dynamic> data) async {
    return await remoteDataSource.addCommunityPost(data);
  }

  @override
  Future<SuccessModel?> communityZoneReport(Map<String, dynamic> data) async {
    return await remoteDataSource.communityZoneReport(data);
  }

  @override
  Future<CommunityDetailsModel?> communityDetails(
    int communityId,
    String scope,
  ) async {
    return await remoteDataSource.communityPostsDetails(communityId, scope);
  }

  @override
  Future<SuccessModel?> deletePost(String id) async {
    return await remoteDataSource.deletePost(id);
  }
}
