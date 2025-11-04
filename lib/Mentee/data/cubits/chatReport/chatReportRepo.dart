import 'package:mentivisor/Mentee/data/remote_data_source.dart';

import '../../../Models/SuccessModel.dart';

abstract class ChatReportRepo {
  Future<SuccessModel?> groupChatReport(Map<String, dynamic> data);
  Future<SuccessModel?> privateChatReport(Map<String, dynamic> data);
}

class ChatReportImpl extends ChatReportRepo {
  final RemoteDataSource remoteDataSource;
  ChatReportImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> groupChatReport(Map<String, dynamic> data) async {
    return await remoteDataSource.groupChatReport(data);
  }

  @override
  Future<SuccessModel?> privateChatReport(Map<String, dynamic> data) async {
    return await remoteDataSource.privateChatReport(data);
  }
}
