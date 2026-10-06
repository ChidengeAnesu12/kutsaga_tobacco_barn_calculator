import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/kutsaga_logo.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _proceed();
  }

  Future<void> _proceed() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.vibrantGreen, Color(0xFF112C00)]),
        ),
        child: const Center(child: KutsagaLogo(light: true, height: 72)),
      ),
    );
  }
}