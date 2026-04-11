import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'RemindRx'**
  String get appTitle;

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'Your Smart Health Companion'**
  String get appSlogan;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login to manage your medical routines.'**
  String get pleaseLogin;

  /// No description provided for @tracker.
  ///
  /// In en, this message translates to:
  /// **'Daily Tracker'**
  String get tracker;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// No description provided for @pickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick Time'**
  String get pickTime;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @take.
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get take;

  /// No description provided for @takenToday.
  ///
  /// In en, this message translates to:
  /// **'Taken Today'**
  String get takenToday;

  /// No description provided for @dosesLeft.
  ///
  /// In en, this message translates to:
  /// **'Doses Left'**
  String get dosesLeft;

  /// No description provided for @noDoses.
  ///
  /// In en, this message translates to:
  /// **'No doses scheduled for today'**
  String get noDoses;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @meds.
  ///
  /// In en, this message translates to:
  /// **'Meds'**
  String get meds;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @alarmsReminders.
  ///
  /// In en, this message translates to:
  /// **'Alarms and reminders'**
  String get alarmsReminders;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @madeBy.
  ///
  /// In en, this message translates to:
  /// **'Made By BitXero'**
  String get madeBy;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @phoneCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get phoneCountryCode;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your health profile to get started.'**
  String get createAccount;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLength;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get nameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @passwordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get passwordMatch;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get countryCode;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance & Reports'**
  String get performance;

  /// No description provided for @healthCompliance.
  ///
  /// In en, this message translates to:
  /// **'Health Compliance'**
  String get healthCompliance;

  /// No description provided for @weeklyAdherence.
  ///
  /// In en, this message translates to:
  /// **'Weekly Adherence'**
  String get weeklyAdherence;

  /// No description provided for @todayOverview.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Overview'**
  String get todayOverview;

  /// No description provided for @yesterdayOverview.
  ///
  /// In en, this message translates to:
  /// **'Yesterday\'s Overview'**
  String get yesterdayOverview;

  /// No description provided for @weeklyOverview.
  ///
  /// In en, this message translates to:
  /// **'Weekly Overview'**
  String get weeklyOverview;

  /// No description provided for @dayOverview.
  ///
  /// In en, this message translates to:
  /// **'{day}\'s Overview'**
  String dayOverview(Object day);

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Actionable Insights'**
  String get insights;

  /// No description provided for @perfectDay.
  ///
  /// In en, this message translates to:
  /// **'Perfect Day!'**
  String get perfectDay;

  /// No description provided for @incredibleJob.
  ///
  /// In en, this message translates to:
  /// **'Incredible Job!'**
  String get incredibleJob;

  /// No description provided for @almostPerfect.
  ///
  /// In en, this message translates to:
  /// **'Almost Perfect!'**
  String get almostPerfect;

  /// No description provided for @doingGood.
  ///
  /// In en, this message translates to:
  /// **'Doing Good!'**
  String get doingGood;

  /// No description provided for @toughDay.
  ///
  /// In en, this message translates to:
  /// **'Tough Day'**
  String get toughDay;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention!'**
  String get needsAttention;

  /// No description provided for @gettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get gettingStarted;

  /// No description provided for @compliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get compliance;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @remindRxPremium.
  ///
  /// In en, this message translates to:
  /// **'RemindRx'**
  String get remindRxPremium;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0 (Build 42)'**
  String get appVersion;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'RemindRx is your ultimate intelligent health companion. Expertly crafted to simplify medication tracking, manage smart inventory, and ensure you never miss a dose.'**
  String get appDescription;

  /// No description provided for @developmentTeam.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get developmentTeam;

  /// No description provided for @devTeamNames.
  ///
  /// In en, this message translates to:
  /// **'Mohammed Qasim\nAli Khalil\nAbdulqader Taha'**
  String get devTeamNames;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'© 2026 BitXero. All Rights Reserved.'**
  String get allRightsReserved;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @emailReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Email (Read Only)'**
  String get emailReadOnly;

  /// No description provided for @noEmailProvided.
  ///
  /// In en, this message translates to:
  /// **'No email provided'**
  String get noEmailProvided;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @passwordNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Password change not implemented yet.'**
  String get passwordNotImplemented;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @accountSaved.
  ///
  /// In en, this message translates to:
  /// **'Account settings saved successfully!'**
  String get accountSaved;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your data'**
  String get deleteAccountDesc;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone.'**
  String get deleteAccountConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteMedicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Medicine'**
  String get deleteMedicineTitle;

  /// No description provided for @deleteMedicineConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this medicine? This action cannot be undone.'**
  String get deleteMedicineConfirm;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Continue to Details'**
  String get stepDetails;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @specialNotes.
  ///
  /// In en, this message translates to:
  /// **'Any special notes? (e.g., Take after food)'**
  String get specialNotes;

  /// No description provided for @frequencyQuestion.
  ///
  /// In en, this message translates to:
  /// **'When & How Many?'**
  String get frequencyQuestion;

  /// No description provided for @frequencyDesc.
  ///
  /// In en, this message translates to:
  /// **'We will set up the alarms for you.'**
  String get frequencyDesc;

  /// No description provided for @timesPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Times'**
  String timesPerDayLabel(Object count);

  /// No description provided for @atWhatTimes.
  ///
  /// In en, this message translates to:
  /// **'At what times?'**
  String get atWhatTimes;

  /// No description provided for @doseN.
  ///
  /// In en, this message translates to:
  /// **'Dose {index}'**
  String doseN(Object index);

  /// No description provided for @pill.
  ///
  /// In en, this message translates to:
  /// **'Pill'**
  String get pill;

  /// No description provided for @capsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get capsule;

  /// No description provided for @liquid.
  ///
  /// In en, this message translates to:
  /// **'Liquid / Syrup'**
  String get liquid;

  /// No description provided for @injection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get injection;

  /// No description provided for @inhaler.
  ///
  /// In en, this message translates to:
  /// **'Inhaler'**
  String get inhaler;

  /// No description provided for @drops.
  ///
  /// In en, this message translates to:
  /// **'Drops'**
  String get drops;

  /// No description provided for @cream.
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get cream;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @amountCream.
  ///
  /// In en, this message translates to:
  /// **'Amount (e.g. 1 fingertip)'**
  String get amountCream;

  /// No description provided for @stockCream.
  ///
  /// In en, this message translates to:
  /// **'Gram/tube capacity left'**
  String get stockCream;

  /// No description provided for @freqCream.
  ///
  /// In en, this message translates to:
  /// **'How many times to apply?'**
  String get freqCream;

  /// No description provided for @amountDrops.
  ///
  /// In en, this message translates to:
  /// **'How many drops?'**
  String get amountDrops;

  /// No description provided for @stockDrops.
  ///
  /// In en, this message translates to:
  /// **'Drops left in bottle (est)'**
  String get stockDrops;

  /// No description provided for @freqDrops.
  ///
  /// In en, this message translates to:
  /// **'How many times a day?'**
  String get freqDrops;

  /// No description provided for @amountInjection.
  ///
  /// In en, this message translates to:
  /// **'Injection Volume'**
  String get amountInjection;

  /// No description provided for @stockInjection.
  ///
  /// In en, this message translates to:
  /// **'Remaining injections/vials'**
  String get stockInjection;

  /// No description provided for @freqInjection.
  ///
  /// In en, this message translates to:
  /// **'How many injections a day?'**
  String get freqInjection;

  /// No description provided for @amountLiquid.
  ///
  /// In en, this message translates to:
  /// **'Dose volume (e.g. 10)'**
  String get amountLiquid;

  /// No description provided for @stockLiquid.
  ///
  /// In en, this message translates to:
  /// **'Total liquid left (ml)'**
  String get stockLiquid;

  /// No description provided for @freqLiquid.
  ///
  /// In en, this message translates to:
  /// **'How many times a day?'**
  String get freqLiquid;

  /// No description provided for @amountInhaler.
  ///
  /// In en, this message translates to:
  /// **'How many puffs?'**
  String get amountInhaler;

  /// No description provided for @stockInhaler.
  ///
  /// In en, this message translates to:
  /// **'Puffs remaining in inhaler'**
  String get stockInhaler;

  /// No description provided for @freqInhaler.
  ///
  /// In en, this message translates to:
  /// **'How many times a day?'**
  String get freqInhaler;

  /// No description provided for @amountPill.
  ///
  /// In en, this message translates to:
  /// **'Dose (e.g. 1 pill or 500mg)'**
  String get amountPill;

  /// No description provided for @stockPill.
  ///
  /// In en, this message translates to:
  /// **'Pills/Capsules left in box'**
  String get stockPill;

  /// No description provided for @freqPill.
  ///
  /// In en, this message translates to:
  /// **'How many times a day?'**
  String get freqPill;

  /// No description provided for @stockAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully added {amount} to {name}\'s stock. Total is now {total}'**
  String stockAddedSuccess(int amount, String name, int total);

  /// No description provided for @unitPill.
  ///
  /// In en, this message translates to:
  /// **'pill(s)'**
  String get unitPill;

  /// No description provided for @unitMg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get unitMg;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @durationAndFrequency.
  ///
  /// In en, this message translates to:
  /// **'Duration & Frequency'**
  String get durationAndFrequency;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every Day'**
  String get everyDay;

  /// No description provided for @everyWeek.
  ///
  /// In en, this message translates to:
  /// **'Every Week'**
  String get everyWeek;

  /// No description provided for @everyMonth.
  ///
  /// In en, this message translates to:
  /// **'Every Month'**
  String get everyMonth;

  /// No description provided for @everyYear.
  ///
  /// In en, this message translates to:
  /// **'Every Year'**
  String get everyYear;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateLabel;

  /// No description provided for @endsOptional.
  ///
  /// In en, this message translates to:
  /// **'Ends (Optional)'**
  String get endsOptional;

  /// No description provided for @infinite.
  ///
  /// In en, this message translates to:
  /// **'Infinite'**
  String get infinite;

  /// No description provided for @scheduleCreated.
  ///
  /// In en, this message translates to:
  /// **'Schedule created successfully!'**
  String get scheduleCreated;

  /// No description provided for @activateSchedule.
  ///
  /// In en, this message translates to:
  /// **'ACTIVATE SCHEDULE'**
  String get activateSchedule;

  /// No description provided for @remindersLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Take with food'**
  String get notesHint;

  /// No description provided for @refillStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Refill Stock'**
  String get refillStockTitle;

  /// No description provided for @refillStockDesc.
  ///
  /// In en, this message translates to:
  /// **'Add new quantity to your current inventory to ensure continuous supply.'**
  String get refillStockDesc;

  /// No description provided for @customMedicineTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Medicine Type'**
  String get customMedicineTypeLabel;

  /// No description provided for @customMedicineTypeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Patch, Lotion...'**
  String get customMedicineTypeHint;

  /// No description provided for @genericAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get genericAmountLabel;

  /// No description provided for @genericStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining Stock'**
  String get genericStockLabel;

  /// No description provided for @genericFreqLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get genericFreqLabel;

  /// No description provided for @didYouTakeDose.
  ///
  /// In en, this message translates to:
  /// **'Did you take {medicine} today?'**
  String didYouTakeDose(String medicine);

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @lowStockAlert.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alert'**
  String get lowStockAlert;

  /// No description provided for @dailyAdherence.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get dailyAdherence;

  /// No description provided for @doseTakenSuccess.
  ///
  /// In en, this message translates to:
  /// **'Dose logged successfully. Wishing you good health.'**
  String get doseTakenSuccess;

  /// No description provided for @doseSkippedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Dose skipped.'**
  String get doseSkippedSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
