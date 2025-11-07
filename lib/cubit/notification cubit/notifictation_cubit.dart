import 'package:app_devfest/api/notification/notification_service_api.dart';
import 'package:app_devfest/cubit/notification%20cubit/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationApiService _notificationApiService =
      NotificationApiService();

  NotificationCubit() : super(NotificationInitial());

  Future<void> sendNotificationToUser({
    required String userId,
    required String message,
  }) async {
    emit(NotificationLoading());

    try {
      final result = await _notificationApiService.sendNotificationToUser(
        userId: userId,
        message: message,
      );

      if (result['success'] == true) {
        emit(NotificationSuccess(
          result['message'] ?? 'Notification sent successfully',
          timestamp: result['timestamp'],
          userId: result['userId'],
        ));
      } else {
        print('Notification sending failed: ${result['error']}');
        emit(NotificationFailure(
            result['error'] ?? 'Failed to send notification'));
      }
    } catch (e) {
      print('Error during notification sending: $e');
      emit(NotificationFailure('An unexpected error occurred: $e'));
    }
  }

  void reset() {
    emit(NotificationInitial());
  }
}
