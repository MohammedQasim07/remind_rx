import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:remind_rx/core/services/notification_service.dart';
import 'package:remind_rx/core/bloc/notifications/notifications_event.dart';
import 'package:remind_rx/core/bloc/notifications/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final NotificationService _notificationService;

  NotificationsBloc(this._notificationService) : super(const NotificationsState(isEnabled: true)) {
    on<LoadNotificationSettings>((event, emit) async {
      final value = await _storage.read(key: 'notifications_enabled');
      // Default to true if not set
      final isEnabled = value == null || value == 'true';
      _notificationService.setEnabled(isEnabled);
      emit(NotificationsState(isEnabled: isEnabled));
    });

    on<ToggleNotifications>((event, emit) async {
      await _storage.write(key: 'notifications_enabled', value: event.isEnabled.toString());
      _notificationService.setEnabled(event.isEnabled);
      emit(NotificationsState(isEnabled: event.isEnabled));
      
      if (event.isEnabled) {
        // Future: Trigger re-scheduling logic here
      }
    });
  }

  static Future<bool> getInitialNotificationState() async {
    const storage = FlutterSecureStorage();
    final value = await storage.read(key: 'notifications_enabled');
    return value == null || value == 'true';
  }
}
