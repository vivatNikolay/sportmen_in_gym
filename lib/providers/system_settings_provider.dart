import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../models/system_settings.dart';
import '../models/available_locale.dart';
import '../services/system_settings_db.dart';

class SystemSettingsPr extends ChangeNotifier {
  final SystemSettingsDB _dbService = SystemSettingsDB();

  late ThemeMode themeMode;
  late Locale locale;
  late SystemSettings _settings;

  SystemSettingsPr() {
    _settings = _dbService.getFirst() ??
        SystemSettings(
            isDark: true,
            locale: AvailableLocale.values.indexOf(AvailableLocale.ru));
    initSettings();
  }

  void initSettings() {
    _dbService.put(_settings);
    themeMode = _settings.isDark ? ThemeMode.dark : ThemeMode.light;
    locale = AvailableLocale.values[_settings.locale]['locale'];
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  SystemSettings get settings => _settings;

  Future<void> put(SystemSettings settings) async {
    _settings = settings;
    themeMode = settings.isDark ? ThemeMode.dark : ThemeMode.light;
    locale = AvailableLocale.values[_settings.locale]['locale'];
    await _dbService.put(_settings);
    notifyListeners();
  }
}

class MyThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: mainColor,
      titleTextStyle:
          TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
      titleSpacing: 18,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black54,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black54,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: mainColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    colorScheme: const ColorScheme.light(primary: mainColor, secondary: mainColor).copyWith(
      background: const Color(0xFFF3F3F8),
    ),
  );

  static final dark = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1C1C1E),
      appBarTheme: const AppBarTheme(
        backgroundColor: mainColor,
        titleTextStyle:
            TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
        titleSpacing: 18,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.white54,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white54,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: mainColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.white60,
      ),
      colorScheme: const ColorScheme.dark(primary: mainColor, secondary: mainColor).copyWith(
        background: const Color(0xFF1C1C1E),
      ),
  );
}
