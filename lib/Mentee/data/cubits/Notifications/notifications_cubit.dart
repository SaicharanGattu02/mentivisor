import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_repo.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsRepo notificationsRepo;

  NotificationsCubit(this.notificationsRepo)
      : super(NotificationsIntially());

  Future<void> notifiactions() async {
    emit(NotificationsLoading());
    try {
      final res = await notificationsRepo.notifications();
      if (res != null && res.status == true) {
        emit(NotificationsLoaded(notificationModel: res));
      } else {
        emit(NotificationsFailure(msg: res?.message??""));
      }
    } catch (e) {
      emit(NotificationsFailure(msg: "An error occurred: $e"));
    }
  }
}
