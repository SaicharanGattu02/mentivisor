import 'package:mentivisor/Models/MenteeModels/WalletResponseModel.dart';

import '../../services/remote_data_source.dart';

abstract class WalletmoneyRepository{
  Future<WalletResponseModel?> getwalletmoney();
}

class walletmoneyImpl implements WalletmoneyRepository{
  final RemoteDataSource remoteDataSource;

  walletmoneyImpl({required this.remoteDataSource});

  @override
  Future<WalletResponseModel?> getwalletmoney() async {
    return await remoteDataSource.getwalletmoney();

  }
}