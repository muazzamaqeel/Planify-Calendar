import 'package:flutter/material.dart';
import 'screens/main_view/MainWindow.dart'; // Home Screen (Login)
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
      home: const MainWindow(), // Default screen (Login)
      routes: {
        //'/signup': (context) => TempRegistration(), // Route for Sign-Up Page
      },
    );
  }
}
