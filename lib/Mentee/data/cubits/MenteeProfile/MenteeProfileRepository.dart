import 'package:mentivisor/Mentee/Models/MenteeProfileModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';


abstract class MenteeProfileRepository {
  Future<MenteeProfileModel?> getMenteeProfile();
}

class MenteeProfileImpl implements MenteeProfileRepository {
  RemoteDataSource remoteDataSource;
  MenteeProfileImpl({required this.remoteDataSource});

  @override
  Future<MenteeProfileModel?> getMenteeProfile() async {
    return await remoteDataSource.getMenteeProfile();
  }
}
