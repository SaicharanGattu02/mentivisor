import 'package:mentivisor/Mentee/Models/NotificationModel.dart';
import '../../remote_data_source.dart';

abstract class NotificationsRepo {
  Future<NotificationModel?> notifications();
}

class NotificationIml implements NotificationsRepo {
  final RemoteDataSource remoteDataSource;
  NotificationIml({required this.remoteDataSource});
  @override
  Future<NotificationModel?> notifications() async {
    return await remoteDataSource.notifications();
  }
}
