import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const TobaccoBarnCalculatorApp());
}

class TobaccoBarnCalculatorApp extends StatelessWidget {
  const TobaccoBarnCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kutsaga Tobacco Barn Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
      // builder wraps the Navigator itself, so this applies to every
      // screen that gets pushed later too — not just `home`, which a
      // MediaQuery wrapped around just the home widget would miss.
      // 0.85–1.6x: respects a real range of the device's accessibility
      // font setting for body content, while keeping it bounded enough
      // that none of our hand-built layouts can be pushed into
      // overflowing. Chrome clamps tighter still — see AppHeader and
      // the two tab bars below.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: 0.85,
        maxScaleFactor: 1.6,
        child: child!,
      ),
    );
  }
}