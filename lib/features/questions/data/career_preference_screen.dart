import 'package:flutter/material.dart';
import 'career_next_screen.dart';


const Color kPrimary = Color(0xFF00B894);

class CareerPreferenceScreen extends StatefulWidget {
  const CareerPreferenceScreen({Key? key}) : super(key: key);

  @override
  State<CareerPreferenceScreen> createState() => _CareerPreferenceScreenState();
}

class _CareerPreferenceScreenState extends State<CareerPreferenceScreen> {
  int selectedOption = -1;

  double responsive(BuildContext context, double value) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final longestSide = size.longestSide;

    final scaleFactor = (shortestSide / 390 + longestSide / 844) / 2;
    return value * scaleFactor.clamp(0.7, 1.4);
  }

  @override
  Widget build(BuildContext context) {
    final s = (double px) => responsive(context, px);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Container(height: 8, color: kPrimary, width: double.infinity),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: s(18), vertical: s(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CareerHeader(scale: s),
                        SizedBox(height: s(12)),
                        Text(
                          'Are you currently looking for new opportunities?',
                          style: TextStyle(
                            fontSize: s(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: s(12)),
                        _optionCard(
                          s: s,
                          index: 0,
                          icon: Icons.search_rounded,
                          title: "Yes, actively looking",
                          subtitle:
                              "Receive exclusive job invites and get contacted by employers.",
                        ),
                        SizedBox(height: s(12)),
                        _optionCard(
                          s: s,
                          index: 1,
                          icon: Icons.work_outline_rounded,
                          title: "I'm open",
                          subtitle:
                              "Choose this to occasionally receive exclusive job invites.",
                        ),
                        SizedBox(height: s(12)),
                        _optionCard(
                          s: s,
                          index: 2,
                          icon: Icons.close_rounded,
                          title: "Not open",
                          subtitle:
                              "You can change this later by the time you need to find new jobs.",
                        ),
                        SizedBox(height: s(260)),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).maybePop(),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: s(16)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(s(28)),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  backgroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Back',
                                  style: TextStyle(fontSize: s(16), color: Colors.grey[800]),
                                ),
                              ),
                            ),
                            SizedBox(width: s(12)),
                            Expanded(
                              child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CareerNextScreen()),
    );
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: s(16)),
    backgroundColor: kPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(s(28)),
    ),
    elevation: 4,
  ),
  child: Text(
    'Next',
    style: TextStyle(fontSize: s(16), fontWeight: FontWeight.w600),
  ),
),

                            ),
                          ],
                        ),
                        SizedBox(height: s(26)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _optionCard({
    required double Function(double) s,
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = selectedOption == index;

    return GestureDetector(
      onTap: () => setState(() => selectedOption = index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(s(12)),
        decoration: BoxDecoration(
          color: isSelected ? kPrimary.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(s(12)),
          border: Border.all(color: isSelected ? kPrimary : Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: kPrimary.withOpacity(0.12),
              radius: s(18),
              child: Icon(icon, color: kPrimary, size: s(18)),
            ),
            SizedBox(width: s(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: s(15), fontWeight: FontWeight.w600, color: Colors.black)),
                  SizedBox(height: s(6)),
                  Text(subtitle,
                      style: TextStyle(fontSize: s(13), height: 1.3, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareerHeader extends StatelessWidget {
  final double Function(double) scale;
  const _CareerHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Row(
      children: [
        Column(
          children: [
            _StepCircleProgress(fillPercent: 1.0, size: s(28), hasCheck: true),
            SizedBox(height: s(6)),
            Text('Profile', style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
          ],
        ),
        Expanded(
          child: Container(height: s(1), margin: EdgeInsets.symmetric(horizontal: s(10)), color: Colors.grey.shade300),
        ),
        Column(
          children: [
            _StepCircleProgress(fillPercent: 0.50, size: s(28)),
            SizedBox(height: s(6)),
            Text('Career Preference', style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
          ],
        ),
        Expanded(
          child: Container(height: s(1), margin: EdgeInsets.symmetric(horizontal: s(10)), color: Colors.grey.shade300),
        ),
        Column(
          children: [
            _StepCircleProgress(fillPercent: 0.0, size: s(28)),
            SizedBox(height: s(6)),
            Text('Docs', style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
          ],
        ),
      ],
    );
  }
}

class _StepCircleProgress extends StatelessWidget {
  final double fillPercent;
  final double size;
  final bool hasCheck;

  const _StepCircleProgress({
    required this.fillPercent,
    required this.size,
    this.hasCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kPrimary, width: 2),
          ),
        ),
        ClipOval(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: fillPercent.clamp(0.0, 1.0),
            child: Container(width: size, height: size, color: kPrimary),
          ),
        ),
        if (hasCheck)
          Icon(Icons.check, size: size * 0.6, color: Colors.white),
      ],
    );
  }
}

class CareerNextPlaceholder extends StatelessWidget {
  const CareerNextPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career - Next'), backgroundColor: kPrimary),
      body: const Center(child: Text('Career Next (placeholder)')),
    );
  }
}