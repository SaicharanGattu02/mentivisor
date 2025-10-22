import 'package:mentivisor/Mentee/Models/TagsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class EccTagsRepository {
  Future<TagsModel?> getEccTags(String searchQuery);
}

class EccTagsImpl implements EccTagsRepository {
  RemoteDataSource remoteDataSource;
  EccTagsImpl({required this.remoteDataSource});

  @override
  Future<TagsModel?> getEccTags(String searchQuery) async {
    return await remoteDataSource.getEccTags(searchQuery);
  }


}
