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
  String get appSlogan => 'Your Smart Health Companion';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get login => 'Login';

  @override
  String get logIn => 'Log In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get pleaseLogin => 'Please login to manage your medical routines.';

  @override
  String get tracker => 'Daily Tracker';

  @override
  String get medicines => 'Medicines';

  @override
  String get stats => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get addMedicine => 'Add Medicine';

  @override
  String get medicineName => 'Medicine Name';

  @override
  String get dosage => 'Dosage';

  @override
  String get save => 'Save';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get frequency => 'Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get take => 'Take';

  @override
  String get takenToday => 'Taken Today';

  @override
  String get dosesLeft => 'Doses Left';

  @override
  String get noDoses => 'No doses scheduled for today';

  @override
  String get home => 'Home';

  @override
  String get analytics => 'Analytics';

  @override
  String get meds => 'Meds';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get account => 'Account';

  @override
  String get notifications => 'Notifications';

  @override
  String get alarmsReminders => 'Alarms and reminders';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get madeBy => 'Made By BitXero';

  @override
  String get logOut => 'Log Out';

  @override
  String get logoutConfirm =>
      'Are you sure you want to log out of your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get name => 'Full Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get phoneCountryCode => 'Country Code';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create your health profile to get started.';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get passwordLength => 'Password must be at least 6 characters';

  @override
  String get nameRequired => 'Full name is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get passwordMatch => 'Passwords match';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get countryCode => 'Country Code';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get performance => 'Performance & Reports';

  @override
  String get healthCompliance => 'Health Compliance';

  @override
  String get weeklyAdherence => 'Weekly Adherence';

  @override
  String get todayOverview => 'Today\'s Overview';

  @override
  String get yesterdayOverview => 'Yesterday\'s Overview';

  @override
  String get weeklyOverview => 'Weekly Overview';

  @override
  String dayOverview(Object day) {
    return '$day\'s Overview';
  }

  @override
  String get missed => 'Missed';

  @override
  String get total => 'Total';

  @override
  String get insights => 'Actionable Insights';

  @override
  String get perfectDay => 'Perfect Day!';

  @override
  String get incredibleJob => 'Incredible Job!';

  @override
  String get almostPerfect => 'Almost Perfect!';

  @override
  String get doingGood => 'Doing Good!';

  @override
  String get toughDay => 'Tough Day';

  @override
  String get needsAttention => 'Needs Attention!';

  @override
  String get gettingStarted => 'Getting Started';

  @override
  String get compliance => 'Compliance';

  @override
  String get reset => 'Reset';

  @override
  String get remindRxPremium => 'RemindRx';

  @override
  String get appVersion => 'v1.0.0 (Build 42)';

  @override
  String get appDescription =>
      'RemindRx is your ultimate intelligent health companion. Expertly crafted to simplify medication tracking, manage smart inventory, and ensure you never miss a dose.';

  @override
  String get developmentTeam => 'Development Team';

  @override
  String get devTeamNames => 'Mohammed Qasim\nAli Khalil\nAbdulqader Taha';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get website => 'Website';

  @override
  String get allRightsReserved => '© 2026 BitXero. All Rights Reserved.';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get emailReadOnly => 'Email (Read Only)';

  @override
  String get noEmailProvided => 'No email provided';

  @override
  String get changePassword => 'Change Password';

  @override
  String get passwordNotImplemented => 'Password change not implemented yet.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get accountSaved => 'Account settings saved successfully!';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountDesc => 'Permanently remove your data';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to permanently delete your account? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteMedicineTitle => 'Delete Medicine';

  @override
  String get deleteMedicineConfirm =>
      'Are you sure you want to permanently delete this medicine? This action cannot be undone.';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get stepDetails => 'Continue to Details';

  @override
  String get unit => 'Unit';

  @override
  String get specialNotes => 'Any special notes? (e.g., Take after food)';

  @override
  String get frequencyQuestion => 'When & How Many?';

  @override
  String get frequencyDesc => 'We will set up the alarms for you.';

  @override
  String timesPerDayLabel(Object count) {
    return '$count Times';
  }

  @override
  String get atWhatTimes => 'At what times?';

  @override
  String doseN(Object index) {
    return 'Dose $index';
  }

  @override
  String get pill => 'Pill';

  @override
  String get capsule => 'Capsule';

  @override
  String get liquid => 'Liquid / Syrup';

  @override
  String get injection => 'Injection';

  @override
  String get inhaler => 'Inhaler';

  @override
  String get drops => 'Drops';

  @override
  String get cream => 'Cream';

  @override
  String get other => 'Other';

  @override
  String get amountCream => 'Amount (e.g. 1 fingertip)';

  @override
  String get stockCream => 'Gram/tube capacity left';

  @override
  String get freqCream => 'How many times to apply?';

  @override
  String get amountDrops => 'How many drops?';

  @override
  String get stockDrops => 'Drops left in bottle (est)';

  @override
  String get freqDrops => 'How many times a day?';

  @override
  String get amountInjection => 'Injection Volume';

  @override
  String get stockInjection => 'Remaining injections/vials';

  @override
  String get freqInjection => 'How many injections a day?';

  @override
  String get amountLiquid => 'Dose volume (e.g. 10)';

  @override
  String get stockLiquid => 'Total liquid left (ml)';

  @override
  String get freqLiquid => 'How many times a day?';

  @override
  String get amountInhaler => 'How many puffs?';

  @override
  String get stockInhaler => 'Puffs remaining in inhaler';

  @override
  String get freqInhaler => 'How many times a day?';

  @override
  String get amountPill => 'Dose (e.g. 1 pill or 500mg)';

  @override
  String get stockPill => 'Pills/Capsules left in box';

  @override
  String get freqPill => 'How many times a day?';

  @override
  String stockAddedSuccess(int amount, String name, int total) {
    return 'Successfully added $amount to $name\'s stock. Total is now $total';
  }

  @override
  String get unitPill => 'pill(s)';

  @override
  String get unitMg => 'mg';

  @override
  String get unitMl => 'ml';

  @override
  String get durationAndFrequency => 'Duration & Frequency';

  @override
  String get everyDay => 'Every Day';

  @override
  String get everyWeek => 'Every Week';

  @override
  String get everyMonth => 'Every Month';

  @override
  String get everyYear => 'Every Year';

  @override
  String get startDateLabel => 'Start Date';

  @override
  String get endsOptional => 'Ends (Optional)';

  @override
  String get infinite => 'Infinite';

  @override
  String get scheduleCreated => 'Schedule created successfully!';

  @override
  String get activateSchedule => 'ACTIVATE SCHEDULE';

  @override
  String get remindersLabel => 'Reminders';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesHint => 'e.g. Take with food';

  @override
  String get refillStockTitle => 'Refill Stock';

  @override
  String get refillStockDesc =>
      'Add new quantity to your current inventory to ensure continuous supply.';

  @override
  String get customMedicineTypeLabel => 'Custom Medicine Type';

  @override
  String get customMedicineTypeHint => 'e.g. Patch, Lotion...';

  @override
  String get genericAmountLabel => 'Dosage';

  @override
  String get genericStockLabel => 'Remaining Stock';

  @override
  String get genericFreqLabel => 'Frequency';

  @override
  String didYouTakeDose(String medicine) {
    return 'Did you take $medicine today?';
  }

  @override
  String get skip => 'Skip';

  @override
  String get details => 'Details';

  @override
  String get lowStockAlert => 'Low Stock Alert';

  @override
  String get dailyAdherence => 'Today\'s Progress';

  @override
  String get doseTakenSuccess =>
      'Dose logged successfully. Wishing you good health.';

  @override
  String get doseSkippedSuccess => 'Dose skipped.';
}
