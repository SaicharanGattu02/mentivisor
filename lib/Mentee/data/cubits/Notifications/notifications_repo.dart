import 'package:mentivisor/Mentee/Models/NotificationModel.dart';
import '../../remote_data_source.dart';

abstract class NotificationsRepo {
  Future<NotificationModel?> notifications(String role, String filter);
}

class NotificationIml implements NotificationsRepo {
  final RemoteDataSource remoteDataSource;
  NotificationIml({required this.remoteDataSource});
  @override
  Future<NotificationModel?> notifications(String role, String filter) async {
    return await remoteDataSource.notifications(role,filter);
  }
}
