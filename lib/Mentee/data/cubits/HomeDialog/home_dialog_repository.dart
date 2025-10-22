import 'package:mentivisor/Mentee/Models/TagsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/GetHomeDilogModel.dart';
import '../../../Models/StudyZoneTagsModel.dart';

abstract class HomeDialogRepository {
  Future<GetHomeDilogModel?> getHomeDialog();
}

class HomeDialogImpl implements HomeDialogRepository {
  RemoteDataSource remoteDataSource;
  HomeDialogImpl({required this.remoteDataSource});

  @override
  Future<GetHomeDilogModel?> getHomeDialog() async {
    return await remoteDataSource.homeDiolog();
  }
}
