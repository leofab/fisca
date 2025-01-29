import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/onboarding/onboarding_screen.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/home/overview_screen.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auth_provider.dart' as auth_provider;
import 'package:app/screens/camera/camera_view_model.dart';
import 'utils/theme.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger();
  try {
    await Firebase.initializeApp();
    logger.d('Firebase initialized');
  } catch (e) {
    logger.e(e);
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => auth_provider.AuthProvider()),
      ChangeNotifierProvider(create: (_) => CameraViewModel()),
    ],
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
    final authProvider = Provider.of<auth_provider.AuthProvider>(context);
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: authProvider.userData == null
          ? const OnboardingScreen()
          : authProvider.isLoading
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : authProvider.user != null
                  ? OverviewScreen()
                  : const OnboardingScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => OverviewScreen(),
      },
    );
  }
}
