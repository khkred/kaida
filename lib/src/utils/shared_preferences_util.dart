import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('onBoardingComplete') ?? false;
  }

  // Method to clear Preferences for Testing
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
