import '../../../Models/MentorCoinHistoryModel.dart';
import '../../MentorRemoteDataSource.dart';

abstract class CoinHistoryRepo {
  Future<MentorCoinHistoryModel?> getCoinsHistory(String filter);
}

class CoinsHistoryImpl implements CoinHistoryRepo {
  final MentorRemoteDataSource mentorRemoteDataSource;
  CoinsHistoryImpl({required this.mentorRemoteDataSource});

  @override
  Future<MentorCoinHistoryModel?> getCoinsHistory(String filter) async {
    return await mentorRemoteDataSource.CoinsHistory(filter);
  }
}
