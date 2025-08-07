import 'package:mentivisor/Mentee/Models/DownloadsModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class DownloadsRepository {
  Future<DownloadsModel?> getDownloads(int page);
}

class DownloadsRepositoryImpl implements DownloadsRepository {
  RemoteDataSource remoteDataSource;
  DownloadsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DownloadsModel?> getDownloads(int page) async {
    return await remoteDataSource.getDownloads(page);
  }
}
