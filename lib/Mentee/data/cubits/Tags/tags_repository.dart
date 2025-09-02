import 'package:mentivisor/Mentee/Models/TagsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class TagsRepository {
  Future<TagsModel?> getTags();
  Future<TagsModel?> getTagSearch(String query);
}

class TagsImpl implements TagsRepository {
  RemoteDataSource remoteDataSource;
  TagsImpl({required this.remoteDataSource});

  @override
  Future<TagsModel?> getTags() async {
    return await remoteDataSource.getTags();
  }

  @override
  Future<TagsModel?> getTagSearch(String query) async {
    return await remoteDataSource.getTagSearch(query);
  }
}
