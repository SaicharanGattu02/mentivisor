import 'package:mentivisor/Models/CoinsPackRespModel.dart';

import '../../remote_data_source.dart';

abstract class CoinsPackRepo {
  Future<CoinsPackRespModel?> getcoinspack();
}

class CoinspackImpl implements CoinsPackRepo {
  final RemoteDataSource remoteDataSource;

  CoinspackImpl({required this.remoteDataSource});

  @override
  Future<CoinsPackRespModel?> getcoinspack() async {
    return await remoteDataSource.getcoinspack();
  }
}
