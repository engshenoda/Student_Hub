import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Privacy_Policy extends StatefulWidget {
  const Privacy_Policy({super.key});

  @override
  State<Privacy_Policy> createState() => _Privacy_PolicyState();
}

class _Privacy_PolicyState extends State<Privacy_Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FDFB),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Color(0xFF006E59),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAAE7DB), Color(0xFFFBF9FC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF006E59)),
          onPressed: () => context.pop('/settings.dart'),
        ),
      ),
    );
  }
}
