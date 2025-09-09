// REPO
import '../../../Models/UploadFileInChatModel.dart';
import '../../remote_data_source.dart';

abstract class UploadFileInChatRepo {
  Future<UploadFileInChatModel?> uploadFileInChat(Map<String, dynamic> data);
}

class UploadFileInChatRepoImpl implements UploadFileInChatRepo {
  final RemoteDataSource remoteDataSource; // use your existing data source

  UploadFileInChatRepoImpl({required this.remoteDataSource});

  @override
  Future<UploadFileInChatModel?> uploadFileInChat(
      Map<String, dynamic> data) async {
    return await remoteDataSource.uploadFileInChat(data);
  }
}