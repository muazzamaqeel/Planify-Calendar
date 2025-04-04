import 'package:flutter/material.dart';
import 'screens/main_view/MainWindow.dart';
import 'screens/calendar_view/CalendarWindow.dart';
import 'screens/main_view/TempRegistration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Flutter Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainWindow(),
      routes: {
        '/calendar': (context) => const CalendarWindow(),
        '/signup': (context) => const TempRegistration(),
      },
    );
  }
}
