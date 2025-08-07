import 'package:mentivisor/Mentee/data/remote_data_source.dart';
import '../../../Models/MentorProfileModel.dart';

abstract class MentorProfileRepository {
  Future<MentorProfileModel?> getMentorProfile(int id);
}

class MentorProfileRepositoryImpl implements MentorProfileRepository {
  RemoteDataSource remoteDataSource;

  MentorProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MentorProfileModel?> getMentorProfile(int id) async {
    return await remoteDataSource.getMentorProfile(id);
  }
}
