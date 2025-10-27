import 'package:mentivisor/Mentee/Models/MilestonesModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class MilestonesRepo {
  Future<MilestonesModel?> getMilestones();
}

class MilestonesRepoImpl implements MilestonesRepo {
  RemoteDataSource remoteDataSource;
  MilestonesRepoImpl({required this.remoteDataSource});

  @override
  Future<MilestonesModel?> getMilestones() async {
    return await remoteDataSource.getMilestones();
  }
}
