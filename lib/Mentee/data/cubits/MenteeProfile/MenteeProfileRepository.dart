import 'package:mentivisor/Mentee/Models/MenteeProfileModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class MenteeProfileRepository {
  Future<MenteeProfileModel?> getMenteeProfile();
  Future<SuccessModel?> menteeProfileUpdate(final Map<String, dynamic> data);
}

class MenteeProfileImpl implements MenteeProfileRepository {
  RemoteDataSource remoteDataSource;
  MenteeProfileImpl({required this.remoteDataSource});

  @override
  Future<MenteeProfileModel?> getMenteeProfile() async {
    return await remoteDataSource.getMenteeProfile();
  }

  @override
  Future<SuccessModel?> menteeProfileUpdate(
    final Map<String, dynamic> data,
  ) async {
    return await remoteDataSource.menteeProfileUpdate(data);
  }
}
