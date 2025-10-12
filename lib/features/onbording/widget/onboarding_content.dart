import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // compute a smaller cacheWidth to reduce decoding memory and load faster
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final targetWidth = (MediaQuery.of(context).size.width * devicePixelRatio)
        .toInt();
    final cacheWidth = (targetWidth * 0.7).toInt(); // adjust factor as needed

    return Stack(
      children: [
        // background image (fills available space)
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            cacheWidth: cacheWidth,
          ),
        ),

        // optional subtle overlay to improve text contrast
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white10],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.45, 1.0],
              ),
            ),
          ),
        ),

        // centered content (text) — stays centered even when image fills
        Positioned.fill(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
