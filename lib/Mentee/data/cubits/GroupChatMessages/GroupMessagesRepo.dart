import 'package:mentivisor/Mentee/Models/GroupChatMessagesModel.dart';

import '../../remote_data_source.dart';

abstract class GroupMessagesRepository {
  Future<GroupChatMessagesModel?> getGroupChatMessages(int page, String Scope);
}

class GroupMessagesRepositoryImpl implements GroupMessagesRepository {
  RemoteDataSource remoteDataSource;
  GroupMessagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GroupChatMessagesModel?> getGroupChatMessages(int page, String Scope) async {
    return await remoteDataSource.getGroupChatMessages(page,Scope);
  }
}
