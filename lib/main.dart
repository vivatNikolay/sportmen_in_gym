import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/training_settings.dart';
import 'services/db/sportsman_db_service.dart';
import 'services/theme/theme_provider.dart';
import 'models/system_settings.dart';
import 'pages/home.dart';
import 'models/sportsman.dart';
import 'models/subscription.dart';
import 'pages/login/login.dart';
import 'models/training.dart';
import 'models/exercise.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  await hiveInitialization();

  runApp(MyApp());
}

Future<void> hiveInitialization() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SportsmanAdapter());
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(SystemSettingsAdapter());
  Hive.registerAdapter(TrainingSettingsAdapter());
  Hive.registerAdapter(TrainingAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  await Hive.openBox<Sportsman>('sportsman');
  await Hive.openBox<SystemSettings>('system_settings');
  await Hive.openBox<TrainingSettings>('training_settings');
  await Hive.openBox<Training>('training');
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final SportsmanDBService _sportsmanDBService = SportsmanDBService();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          String initialRoute = 'login';
          if (_sportsmanDBService.getFirst() != null) {
            initialRoute = 'home';
          }
          return MaterialApp(
            title: 'Gym',
            darkTheme: MyThemes.dark,
            theme: MyThemes.light,
            themeMode: themeProvider.themeMode,
            initialRoute: initialRoute,
            routes: {
              'home':(context) => const Home(),
              'login':(context) => const Login(),
            },
          );
        },
      );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
