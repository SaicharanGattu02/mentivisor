import 'package:mentivisor/Mentee/Models/checkInModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class DailyCheckInsRepo {
  Future<checkInModel?> dailyCheckIns();
}

class DailyCheckInsImpl implements DailyCheckInsRepo {
  final RemoteDataSource remoteDataSource;
  DailyCheckInsImpl({required this.remoteDataSource});
  Future<checkInModel?> dailyCheckIns() async {
    return await remoteDataSource.dailyCheckins();
  }
}
