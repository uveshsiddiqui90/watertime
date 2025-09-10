import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String _keyStep = "onboarding_step";

  /// Save current step
  static Future<void> saveStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyStep, step);
  }

  /// Get current step
  static Future<int> getStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStep) ?? 1; // Default -> Step 1 (Name screen)
  }

  /// Clear step (e.g., logout or reset)
  static Future<void> clearStep() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyStep);
  }
}
