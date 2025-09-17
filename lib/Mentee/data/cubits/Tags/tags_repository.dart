import 'package:mentivisor/Mentee/Models/TagsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class TagsRepository {
  Future<TagsModel?> getStudyZoneTags();
  Future<TagsModel?> getTagSearch(String query);
}

class TagsImpl implements TagsRepository {
  RemoteDataSource remoteDataSource;
  TagsImpl({required this.remoteDataSource});

  @override
  Future<TagsModel?> getStudyZoneTags() async {
    return await remoteDataSource.getStudyZoneTags();
  }

  @override
  Future<TagsModel?> getTagSearch(String query) async {
    return await remoteDataSource.getTagSearch(query);
  }
}
