import 'package:mentivisor/Mentee/Models/NotificationModel.dart';
import '../../remote_data_source.dart';

abstract class NotificationsRepo {
  Future<NotificationModel?> notifications(String role, String filter,int page);
}

class NotificationIml implements NotificationsRepo {
  final RemoteDataSource remoteDataSource;
  NotificationIml({required this.remoteDataSource});
  @override
  Future<NotificationModel?> notifications(String role, String filter,int page) async {
    return await remoteDataSource.notifications(role,filter,page);
  }
}
