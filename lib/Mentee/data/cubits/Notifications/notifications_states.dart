import 'package:mentivisor/Mentee/Models/NotificationModel.dart';

abstract class NotificationsStates {}

class NotificationsIntially extends NotificationsStates {}

class NotificationsLoading extends NotificationsStates {}

class NotificationsLoaded extends NotificationsStates {
  NotificationModel notificationModel;
  NotificationsLoaded({required this.notificationModel});
}

class NotificationsFailure extends NotificationsStates {
  final String msg;
  NotificationsFailure({required this.msg});
}
