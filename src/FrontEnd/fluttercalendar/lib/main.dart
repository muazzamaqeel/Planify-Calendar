import 'package:flutter/material.dart';
import 'screens/main_view/MainWindow.dart';
import 'screens/calendar_view/CalendarWindow.dart';
import 'screens/main_view/UserRegistration.dart';
import '../screens/calendar_view/components/ThemeNotifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Flutter Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeNotifier.currentTheme,
      home: const MainWindow(),
      routes: {
        '/calendar': (context) => const CalendarWindow(),
        '/signup': (context) => const UserRegistration(),
      },
    );
  }
}
