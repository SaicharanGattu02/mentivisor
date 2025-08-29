import '../../../Models/HighlatedCoinsModel.dart';
import '../../remote_data_source.dart';

abstract class HighlightedCoinsRepository {
  Future<HighlightedCoinsModel?> getHighlitedCoins(String category);
}

class HighlightedCoinsImpl implements HighlightedCoinsRepository {
  final RemoteDataSource remoteDataSource;
  HighlightedCoinsImpl({required this.remoteDataSource});
  @override
  Future<HighlightedCoinsModel?> getHighlitedCoins(String category) async {
    return await remoteDataSource.highlihtedCoins(category);
  }
}
