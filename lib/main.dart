import 'package:flutter/material.dart';
import 'package:linkedin/core/routes/app_router.dart';

void main() {
  runApp(const StudentHub());
}

class StudentHub extends StatelessWidget {
  const StudentHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoute.router,
    );
  }
}
