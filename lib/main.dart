import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/screens/onbording/splash_screen.dart';

void main() {
  runApp(const StudentHub());
}

class StudentHub extends StatelessWidget {
  const StudentHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
