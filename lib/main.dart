import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';
import 'startup_check.dart'; // <-- add this line

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Madi7i Anagnostis',
      theme: ThemeData(
        fontFamily: 'NotoSerifBengali',
        useMaterial3: true,
      ),
      // Kill switch wraps the SplashScreen
      home: const StartupCheck(
        child: SplashScreen(),
      ),
    );
  }
}
