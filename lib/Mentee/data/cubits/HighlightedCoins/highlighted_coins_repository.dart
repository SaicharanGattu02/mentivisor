import '../../../Models/HighlatedCoinsModel.dart';
import '../../remote_data_source.dart';

abstract class HighlightedCoinsRepository {
  Future<HighlightedCoinsModel?> getHighlitedCoins();
}

class HighlightedCoinsImpl implements HighlightedCoinsRepository {
  final RemoteDataSource remoteDataSource;
  HighlightedCoinsImpl({required this.remoteDataSource});
  @override
  Future<HighlightedCoinsModel?> getHighlitedCoins() async {
    return await remoteDataSource.highlihtedCoins();
  }
}
