import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const GoalDenApp());
}

class GoalDenApp extends StatelessWidget {
  const GoalDenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoalDen',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
      ),

      home: const SplashScreen(),
    );
  }
}
