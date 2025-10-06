import 'package:flutter/material.dart';

import '../auth/presentation/widgets/onboarding_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/onboarding_screen1.jpg",
      "title": "Welcome to",
      "subtitle": "Student hub app",
    },
    {
      "image": "assets/onboarding_screen2.jpg",
      "title": "Never Miss Important Updates",
      "subtitle": "",
    },
    {
      "image": "assets/onboarding_screen3.jpg",
      "title": "Keep Everything in One Place",
      "subtitle": "",
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingContent(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                subtitle: onboardingData[index]["subtitle"]!,
              );
            },
          ),

          // Skip Button
          if (_currentPage < onboardingData.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  _controller.jumpToPage(onboardingData.length - 1);
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          // Prev Button
          if (_currentPage > 0)
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text(
                  "Prev",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          // Page Indicators (Dots)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.tealAccent[700]
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          // Floating Button (Next / Get Started)
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.tealAccent[700],
              onPressed: _nextPage,
              child: Icon(
                _currentPage == onboardingData.length - 1
                    ? Icons.done
                    : Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ),

          // Get Started Button (inside page 3)
          if (_currentPage == onboardingData.length - 1)
            Positioned(
              bottom: 110,
              left: 24,
              right: 24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
