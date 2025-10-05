import 'package:flutter/material.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      bottomNavigationBar: CustomBottomNavigationBar(child: Center(child: Text("Home")) ,),
      body: const Center(child: Text('This is the Home Screen')),
    );
  }
}
