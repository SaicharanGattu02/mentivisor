import 'package:mentivisor/Mentee/Models/LeaderBoardModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class LeaderBoardRepo {
  Future<LeaderBoardModel?> getLeaderBoard(String college);
}

class LeaderBoardRepoImpl implements LeaderBoardRepo {
  RemoteDataSource remoteDataSource;
  LeaderBoardRepoImpl({required this.remoteDataSource});

  @override
  Future<LeaderBoardModel?> getLeaderBoard(String college) async {
    return await remoteDataSource.getLeaderBoard(college);
  }
}
