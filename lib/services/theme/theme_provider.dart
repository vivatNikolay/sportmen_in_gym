import 'package:flutter/material.dart';

import '../../models/settings.dart';
import '../db/settings_db_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsDBService _dbService = SettingsDBService();

  late ThemeMode themeMode;
  late Settings _settings;

  ThemeProvider() {
    _settings = _dbService.getFirst() ??
        Settings(isDark: ThemeMode.system == ThemeMode.dark);
    themeMode = initThemeMode();
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    _settings.isDark = isOn;
    _dbService.put(_settings);
    notifyListeners();
  }

  ThemeMode initThemeMode() {
    _dbService.put(_settings);
    if (_settings.isDark) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }
}

class MyThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white70,
      foregroundColor: Colors.black87,
      titleTextStyle: TextStyle(
          fontSize: 22,
          color: Colors.black87,
          fontFamily: 'Times New Roman',
          fontWeight: FontWeight.bold),
      titleSpacing: 18,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
          fontSize: 22,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold),
      titleSpacing: 18,
    ),
  );
}