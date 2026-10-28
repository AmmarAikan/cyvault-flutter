import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AppSettings extends ChangeNotifier {
  AppSettings(this._preferences) {
    _themeMode = ThemeMode.values[_preferences.getInt('theme_mode') ?? 0];
    _localeCode = _preferences.getString('locale');
    _dynamicColor = _preferences.getBool('dynamic_color') ?? true;
    _onlineBreach = _preferences.getBool('online_breach_consent') ?? false;
    _biometric = _preferences.getBool('biometric_second_step') ?? false;
    _autoLockMinutes = _preferences.getInt('auto_lock_minutes') ?? 1;
    _clipboardSeconds = _preferences.getInt('clipboard_seconds') ?? 30;
    _seed = _preferences.getInt('theme_seed') ?? 0xFF2457D6;
  }

  final SharedPreferences _preferences;
  late ThemeMode _themeMode;
  String? _localeCode;
  late bool _dynamicColor;
  late bool _onlineBreach;
  late bool _biometric;
  late int _autoLockMinutes;
  late int _clipboardSeconds;
  late int _seed;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _localeCode == null ? null : Locale(_localeCode!);
  bool get dynamicColor => _dynamicColor;
  bool get onlineBreach => _onlineBreach;
  bool get biometric => _biometric;
  int get autoLockMinutes => _autoLockMinutes;
  int get clipboardSeconds => _clipboardSeconds;
  Color get seedColor => Color(_seed);

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    await _preferences.setInt('theme_mode', value.index);
    notifyListeners();
  }

  Future<void> setLocale(Locale? value) async {
    _localeCode = value?.languageCode;
    if (value == null) {
      await _preferences.remove('locale');
    } else {
      await _preferences.setString('locale', value.languageCode);
    }
    notifyListeners();
  }

  Future<void> setDynamicColor(bool value) async {
    _dynamicColor = value;
    await _preferences.setBool('dynamic_color', value);
    notifyListeners();
  }

  Future<void> setOnlineBreach(bool value) async {
    _onlineBreach = value;
    await _preferences.setBool('online_breach_consent', value);
    notifyListeners();
  }

  Future<void> setBiometric(bool value) async {
    _biometric = value;
    await _preferences.setBool('biometric_second_step', value);
    notifyListeners();
  }

  Future<void> setAutoLockMinutes(int value) async {
    _autoLockMinutes = value.clamp(1, 15);
    await _preferences.setInt('auto_lock_minutes', _autoLockMinutes);
    notifyListeners();
  }

  Future<void> setClipboardSeconds(int value) async {
    _clipboardSeconds = value.clamp(10, 60);
    await _preferences.setInt('clipboard_seconds', _clipboardSeconds);
    notifyListeners();
  }

  Future<void> setSeedColor(Color value) async {
    _seed = value.toARGB32();
    await _preferences.setInt('theme_seed', _seed);
    notifyListeners();
  }
}
