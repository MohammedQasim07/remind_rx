import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  LanguageBloc() : super(const LanguageState(Locale('en'))) {
    on<ChangeLanguage>((event, emit) async {
      await _storage.write(key: 'language_code', value: event.locale.languageCode);
      emit(LanguageState(event.locale));
    });
  }

  static Future<Locale> getInitialLocale() async {
    const storage = FlutterSecureStorage();
    final langCode = await storage.read(key: 'language_code');
    if (langCode != null) {
      return Locale(langCode);
    }
    return const Locale('en');
  }
}
