import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/schedule/domain/entities/schedule.dart';
import '../../features/medicine/domain/entities/medicine.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;

  Future<void> init() async {
    tz.initializeTimeZones();
    // In a real app, you would get the device's local timezone
    tz.setLocalLocation(tz.getLocation('UTC'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Add iOS settings if needed
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
        
    // Request exact alarms for Android 12+
    await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();
  }

  void setEnabled(bool value) {
    _isEnabled = value;
    if (!_isEnabled) {
      cancelAllAlarms();
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap (e.g., mark as taken, open specific screen)
    print('Notification tapped: ${response.payload}');
  }

  Future<void> scheduleMedicineAlarm({
    required Schedule schedule,
    required Medicine medicine,
    required DateTime localAlarmTime,
  }) async {
    if (!_isEnabled) return;
    
    // Basic implementation for EXACT alarms.
    // In production, Android requires exact alarm permissions (SCHEDULE_EXACT_ALARM).
    
    // Create a unique integer ID based on schedule ID and alarm time
    final int alarmId = schedule.id.hashCode ^ localAlarmTime.hashCode;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'medicine_reminders_channel',
      'Medicine Reminders',
      channelDescription: 'Reminders for taking your medication',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(localAlarmTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      alarmId,
      'Time for your medicine!',
      'Please take ${medicine.name} (${medicine.dosageAmount} ${medicine.type.name})',
      tzScheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '${schedule.id}|${medicine.id}',
      matchDateTimeComponents: schedule.repeatType == RepeatType.daily 
          ? DateTimeComponents.time 
          : null,
    );
  }

  Future<void> cancelAlarm(int alarmId) async {
    await _notificationsPlugin.cancel(alarmId);
  }

  Future<void> cancelAllAlarms() async {
    await _notificationsPlugin.cancelAll();
  }
}
