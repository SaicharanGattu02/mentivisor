import 'package:mentivisor/Mentee/Models/DownloadsModel.dart';
import 'package:mentivisor/Mentee/Models/SuccessModel.dart';
import 'package:mentivisor/Mentee/data/remote_data_source.dart';

abstract class DownloadsRepository {
  Future<DownloadsModel?> getDownloads(int page);
  Future<SuccessModel?> deleteDownload(String id);
}

class DownloadsRepositoryImpl implements DownloadsRepository {
  RemoteDataSource remoteDataSource;
  DownloadsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DownloadsModel?> getDownloads(int page) async {
    return await remoteDataSource.getDownloads(page);
  }

  @override
  Future<SuccessModel?> deleteDownload(String id) async {
    return await remoteDataSource.deleteDownload(id);
  }
}
