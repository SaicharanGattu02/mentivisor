import 'package:mentivisor/Mentee/Models/GuestMentorsModel.dart';

import '../../remote_data_source.dart';

abstract class GuestMentorsRepository {
  Future<GuestMentorsModel?> getGuestMentorsList();
}

class GuestMentorsRepositoryImpl implements GuestMentorsRepository {
  final RemoteDataSource remoteDataSource;

  GuestMentorsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GuestMentorsModel?> getGuestMentorsList() async {
    return await remoteDataSource.getGuestMentorsList();
  }
}
