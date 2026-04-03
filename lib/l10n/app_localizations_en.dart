// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RemindRx';

  @override
  String get goodMorning => 'Good Morning,';

  @override
  String get user => 'User';

  @override
  String get dosesLeft => 'Doses Left';

  @override
  String get taken => 'Taken';

  @override
  String get todaysSchedule => 'Today\'s Schedule';

  @override
  String get seeAll => 'See All';
}
