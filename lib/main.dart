import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/onboarding/onboarding_screen.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auth_provider.dart';
import 'utils/theme.dart';
import 'package:logger/logger.dart';
import 'package:app/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger();
  try {
    await Firebase.initializeApp();
    logger.d('Firebase initialized');
  } catch (e) {
    logger.e(e);
  }

  runApp(ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding', // Start with onboarding
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
