import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/Models/NotificationModel.dart';
import 'notifications_repo.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  final NotificationsRepo notificationsRepo;

  NotificationsCubit(this.notificationsRepo) : super(NotificationsInitial());

  NotificationModel notificationModel = NotificationModel();
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  /// 🔹 Fetch initial notifications
  Future<void> fetchNotifications(String role, String filter) async {
    emit(NotificationsLoading());
    _currentPage = 1;

    try {
      final response =
      await notificationsRepo.notifications(role, filter, _currentPage);

      if (response != null && response.status == true) {
        notificationModel = response;

        // Determine if there’s a next page
        _hasNextPage = response.notify?.nextPageUrl != null;

        emit(NotificationsLoaded(notificationModel, _hasNextPage));
      } else {
        emit(NotificationsFailure(
            message: response?.message ?? "Failed to load notifications."));
      }
    } catch (e) {
      emit(NotificationsFailure(message: "An error occurred: $e"));
    }
  }

  /// 🔹 Fetch more notifications (pagination)
  Future<void> fetchMoreNotifications(String role, String filter) async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;

    emit(NotificationsLoadingMore(notificationModel, _hasNextPage));

    try {
      final newResponse =
      await notificationsRepo.notifications(role, filter, _currentPage);

      if (newResponse != null &&
          newResponse.notify?.data?.isNotEmpty == true) {
        final oldList = notificationModel.notify?.data ?? [];
        final newList = newResponse.notify?.data ?? [];

        // Combine old + new notifications
        final combinedList = List<Data>.from(oldList)..addAll(newList);

        // Create updated Notify object
        final updatedNotify = Notify(
          currentPage: newResponse.notify?.currentPage,
          data: combinedList,
          firstPageUrl: newResponse.notify?.firstPageUrl,
          from: newResponse.notify?.from,
          lastPage: newResponse.notify?.lastPage,
          lastPageUrl: newResponse.notify?.lastPageUrl,
          links: newResponse.notify?.links,
          nextPageUrl: newResponse.notify?.nextPageUrl,
          path: newResponse.notify?.path,
          perPage: newResponse.notify?.perPage,
          prevPageUrl: newResponse.notify?.prevPageUrl,
          to: newResponse.notify?.to,
          total: newResponse.notify?.total,
        );

        // Update main model
        notificationModel = NotificationModel(
          status: newResponse.status,
          message: newResponse.message,
          notify: updatedNotify,
          currentPage: newResponse.currentPage,
          lastPage: newResponse.lastPage,
          total: newResponse.total,
        );

        // Check next page availability
        _hasNextPage = newResponse.notify?.nextPageUrl != null;

        emit(NotificationsLoaded(notificationModel, _hasNextPage));
      } else {
        _hasNextPage = false;
      }
    } catch (e) {
      emit(NotificationsFailure(message: "An error occurred: $e"));
    } finally {
      _isLoadingMore = false;
    }
  }
}
