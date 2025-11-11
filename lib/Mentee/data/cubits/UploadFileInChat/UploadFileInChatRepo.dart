// REPO
import '../../../Models/UploadFileInChatModel.dart';
import '../../remote_data_source.dart';

abstract class UploadFileInChatRepo {
  Future<UploadFileInChatModel?> uploadFileInChat(Map<String, dynamic> data,String user_id, String session_id);
}

class UploadFileInChatRepoImpl implements UploadFileInChatRepo {
  final RemoteDataSource remoteDataSource; // use your existing data source

  UploadFileInChatRepoImpl({required this.remoteDataSource});

  @override
  Future<UploadFileInChatModel?> uploadFileInChat(
      Map<String, dynamic> data, String user_id, String session_id) async {
    return await remoteDataSource.uploadFileInChat(data,user_id, session_id);
  }
}