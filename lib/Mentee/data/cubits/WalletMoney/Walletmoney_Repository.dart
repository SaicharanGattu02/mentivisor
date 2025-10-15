import '../../../../Mentor/Models/CoinsAchievementModel.dart';
import '../../../Models/WalletModel.dart';
import '../../remote_data_source.dart';

abstract class WalletmoneyRepository {
  Future<WalletModel?> getWallet(int id,int page);
  Future<CoinsAchievementModel?> getCoinsAchievements(int page);
}

class walletmoneyImpl implements WalletmoneyRepository {
  final RemoteDataSource remoteDataSource;

  walletmoneyImpl({required this.remoteDataSource});

  @override
  Future<WalletModel?> getWallet(int id,int page) async {
    return await remoteDataSource.getWallet(id,page);
  }
  @override
  Future<CoinsAchievementModel?> getCoinsAchievements(int page) async {
    return await remoteDataSource.getcoinsAchievements(page);
  }
}
