import 'package:flutter/material.dart';
import '../services/language_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  LanguageProvider() {
    // Load saved language preference when the provider is initialized
    loadSavedLanguage();
  }

  Locale get locale => _locale;

  // Load the saved language from preferences
  Future<void> loadSavedLanguage() async {
    final String languageCode = await LanguagePreferences.getLanguageCode();
    setLocale(Locale(languageCode));
  }

  // Set the locale and save the preference
  void setLocale(Locale locale) {
    _locale = locale;
    LanguagePreferences.setLanguageCode(locale.languageCode);
    notifyListeners();
  }

  // Get language name based on language code
  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
}
