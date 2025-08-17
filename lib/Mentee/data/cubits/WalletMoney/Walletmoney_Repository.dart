import '../../../Models/WalletModel.dart';
import '../../remote_data_source.dart';

abstract class WalletmoneyRepository {
  Future<WalletModel?> getWallet(int id,int page);
}

class walletmoneyImpl implements WalletmoneyRepository {
  final RemoteDataSource remoteDataSource;

  walletmoneyImpl({required this.remoteDataSource});

  @override
  Future<WalletModel?> getWallet(int id,int page) async {
    return await remoteDataSource.getWallet(id,page);
  }
}
