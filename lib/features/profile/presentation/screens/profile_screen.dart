import 'package:flutter/material.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(child: Center(child: Text("profile")) ,),

      appBar: AppBar(title: const Text('Profile Screen')),
      body: const Center(child: Text('This is the Profile Screen')),
    );
  }
}
