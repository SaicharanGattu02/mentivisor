import 'package:mentivisor/Mentee/Models/NotificationModel.dart';

abstract class NotificationsStates {}

class NotificationsInitial extends NotificationsStates {}

class NotificationsLoading extends NotificationsStates {}

class NotificationsLoaded extends NotificationsStates {
  final NotificationModel notificationModel;
  final bool hasNextPage;

  NotificationsLoaded(this.notificationModel, this.hasNextPage);
}

class NotificationsLoadingMore extends NotificationsStates {
  final NotificationModel notificationModel;
  final bool hasNextPage;

  NotificationsLoadingMore(this.notificationModel, this.hasNextPage);
}

class NotificationsFailure extends NotificationsStates {
  final String message;
  NotificationsFailure({required this.message});
}
