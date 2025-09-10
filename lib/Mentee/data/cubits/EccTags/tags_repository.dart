import 'package:mentivisor/Mentee/Models/TagsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class EccTagsRepository {
  Future<TagsModel?> getEccTags();
  Future<TagsModel?> getEccTagSearch(String query);
}

class EccTagsImpl implements EccTagsRepository {
  RemoteDataSource remoteDataSource;
  EccTagsImpl({required this.remoteDataSource});

  @override
  Future<TagsModel?> getEccTags() async {
    return await remoteDataSource.getEccTags();
  }

  @override
  Future<TagsModel?> getEccTagSearch(String query) async {
    return await remoteDataSource.getEccTagsSearch(query);
  }
}
