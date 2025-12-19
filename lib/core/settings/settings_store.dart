import 'package:shared_preferences/shared_preferences.dart';

class SettingsStore {
  static const _kSensitivity = 'sensitivity';
  static const _kBatterySaver = 'battery_saver';

  Future<double> loadSensitivity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kSensitivity) ?? 0.25; // 기본: 낮게
  }

  Future<void> saveSensitivity(double v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kSensitivity, v.clamp(0.0, 1.0));
  }

  Future<bool> loadBatterySaver() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBatterySaver) ?? false;
  }

  Future<void> saveBatterySaver(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBatterySaver, v);
  }
}
