import 'package:mentivisor/Mentee/Models/TagsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/StudyZoneTagsModel.dart';

abstract class TagsRepository {
  Future<StudyZoneTagsModel?> getStudyZoneTags(String searchQuery);
  // Future<TagsModel?> getTagSearch(String query);
}

class TagsImpl implements TagsRepository {
  RemoteDataSource remoteDataSource;
  TagsImpl({required this.remoteDataSource});

  @override
  Future<StudyZoneTagsModel?> getStudyZoneTags(String searchQuery) async {
    return await remoteDataSource.getStudyZoneTags(searchQuery);
  }

  // @override
  // Future<TagsModel?> getTagSearch(String query) async {
  //   return await remoteDataSource.getTagSearch(query);
  // }
}
