import 'package:mentivisor/Mentee/data/remote_data_source.dart';
import '../../../Models/CommonProfileModel.dart';
import '../../../Models/MenteeProfileModel.dart';
import '../../../Models/MentorProfileModel.dart';

abstract class CommonProfileRepository {
  Future<CommonProfileModel?> commonProfile(int id);
}

class CommonProfileRepositoryImpl implements CommonProfileRepository {
  RemoteDataSource remoteDataSource;

  CommonProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CommonProfileModel?> commonProfile(int id) async {
    return await remoteDataSource.commonProfile(id);
  }
}
