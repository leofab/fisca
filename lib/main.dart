import 'package:app/screens/onboarding/onboarding_view_model.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/screens/charts/line_chart_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/onboarding/onboarding_screen.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/home/overview_screen.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auth_provider.dart' as auth_provider;
import 'package:app/screens/extracted/extracted_view.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view.dart';
import 'package:app/screens/loading/loading_screen.dart';
import 'package:app/service/db_service.dart';
import 'utils/theme.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger();
  try {
    await Firebase.initializeApp();
    logger.d('Firebase initialized');
    try {
      await DBService().initializeDB();
      logger.d('DB initialized');
    } catch (e) {
      Logger().e(e);
    }
  } catch (e) {
    logger.e(e);
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => auth_provider.AuthProvider()),
      ChangeNotifierProvider(create: (context) => YoloExtractedViewModel()),
      ChangeNotifierProvider(create: (context) => LineChartViewModel()),
      ChangeNotifierProvider(create: (context) => OnboardingViewModel()),
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
      home: authProvider.isLoading
          ? const LoadingScreen()
          : authProvider.user != null
              ? OverviewScreen(
                  lineChartViewModel: context.read(),
                  yoloExtractedViewModel: context.read(),
                )
              : const OnboardingScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => OverviewScreen(
              lineChartViewModel: context.read(),
              yoloExtractedViewModel: context.read(),
            ),
        '/extracted': (context) => const ExtractedView(),
        '/yolo': (context) => YoloExtractedView(),
      },
    );
  }
}
