import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  static const String _languageCodeKey = 'language_code';

  // Save the selected language code to shared preferences
  static Future<void> setLanguageCode(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  // Get the saved language code from shared preferences
  static Future<String> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey) ?? 'en'; // Default to English
  }
}
