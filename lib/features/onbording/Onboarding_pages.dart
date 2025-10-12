import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';

import 'widget/onboarding_content.dart';

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
      GoRouter.of(context).push(Routes.createAccaount);
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
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                        ? AppColors.primary
                        : AppColors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          // show FAB only on pages before the last
          if (_currentPage < onboardingData.length - 1)
            Positioned(
              bottom: 40,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.tealAccent[700],
                onPressed: _nextPage,
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ),

          // Get Started Button (inside page 3)
          if (_currentPage == onboardingData.length - 1)
            Positioned(
              bottom: 110,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  CustomBottom(
                    title: "Create Account",
                    onPressed: () {
                      GoRouter.of(context).push(Routes.createAccaount);
                    },
                  ),
                  SizedBox(height: 16),
                  CustomBottom(
                    onPressed: () {
                      GoRouter.of(context).push(Routes.login);
                    },
                    title: "Login",
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
