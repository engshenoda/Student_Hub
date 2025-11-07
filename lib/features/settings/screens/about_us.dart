import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "ABOUT US",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10111A),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "From they fine john he give of rich he. They age and draw mrs like. Improving end distrusts may instantly was household applauded incommode. Why kept very ever home mrs. Considered sympathize ten uncommonly occasional assistance sufficient not.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF97918B),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('');
              },
              child: Text(
                "Explore More",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF008A6F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // no rounding at all
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
