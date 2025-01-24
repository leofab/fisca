import 'package:flutter/material.dart';
import './screens/onboarding/onboarding_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final int _currentIndex = 0;

  final List<Widget> _screens = [OnboardingScreen()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        body: _screens[_currentIndex],
      ),
    );
  }
}
