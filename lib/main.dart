import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/screens/OnboardingScreen1.dart';

import 'features/auth/presentation/screens/OnboardingScreen2.dart';
import 'features/auth/presentation/screens/OnboardingScreen3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen1(),
      routes: {
        '/OnboardingScreen1.dart': (context) => OnboardingScreen1(),
        '/OnboardingScreen2.dart': (context) => OnboardingScreen2(),
        '/OnboardingScreen3.dart': (context) => OnboardingScreen3(),
      },
    );
  }
}
