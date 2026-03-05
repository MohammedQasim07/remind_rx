import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneHelper {
  static void init() {
    tz.initializeTimeZones();
    
    // In a real application, you'd use flutter_timezone to get the actual local timezone string.
    // e.g. final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    // Fallback to UTC if it fails.
    try {
      // tz.setLocalLocation(tz.getLocation(timeZoneName));
      tz.setLocalLocation(tz.local); // Using system default just for illustration
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  /// Converts a UTC DateTime to the configured local Timezone's TZDateTime
  static tz.TZDateTime toLocalTZ(DateTime utcDateTime) {
    return tz.TZDateTime.from(utcDateTime, tz.local);
  }

  /// Converts local DateTime to UTC
  static DateTime toUtc(DateTime localDateTime) {
    return localDateTime.toUtc();
  }
}
