import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/profile/presentation/screens/profile_screen.dart';
import 'package:linkedin/features/questions/data/career_final.dart';
import 'profile_screen.dart';

const Color kPrimary = Color(0xFF00B894);

class DocsScreen extends StatelessWidget {
  const DocsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double rh(double value) => height * (value / 844);
    double rw(double value) => width * (value / 390);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: rw(24), vertical: rh(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 الخط العلوي (Profile - Career Preference - Docs)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStep("Profile", true, false, false),
                  _buildStep("Career Preference", true, false, false),
                  _buildStep("Docs", false, false, true),
                ],
              ),

              SizedBox(height: rh(40)),

              // 🔹 العنوان الرئيسي
              Text(
                "Upload Your Documents",
                style: TextStyle(
                  fontSize: rw(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),

              SizedBox(height: rh(24)),

              // 🔹 CV Section
              Text(
                "CV",
                style: TextStyle(
                  fontSize: rw(16),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: rh(10)),
              _buildAddBox(rw, rh, "Add CV"),

              SizedBox(height: rh(30)),

              // 🔹 Portfolio Section
              Text(
                "Portfolio",
                style: TextStyle(
                  fontSize: rw(16),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: rh(10)),
              _buildAddBox(rw, rh, "Add Portfolio"),

              SizedBox(height: rh(220)),

              // 🔹 أزرار Back & Next
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CarerrScreenFinal(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: rh(16)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(rw(28)),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: rw(16),
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: rw(12)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push(Routes.Home);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: rh(16)),
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(rw(28)),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: rw(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: rh(20)),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 دالة بناء الكور اللي فوق
  Widget _buildStep(
    String title,
    bool isDone,
    bool isOutlined,
    bool isHalfFilled,
  ) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kPrimary, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CustomPaint(
              painter: _HalfCirclePainter(isDone, isOutlined, isHalfFilled),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: (isDone || isHalfFilled) ? kPrimary : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 🔹 دالة بناء Box الإضافة
  Widget _buildAddBox(
    double Function(double) rw,
    double Function(double) rh,
    String label,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: rh(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, color: Colors.black54, size: 20),
          SizedBox(width: rw(8)),
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontSize: rw(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Painter لنص الكورة الملون
class _HalfCirclePainter extends CustomPainter {
  final bool isDone;
  final bool isOutlined;
  final bool isHalfFilled;

  _HalfCirclePainter(this.isDone, this.isOutlined, this.isHalfFilled);

  @override
  void paint(Canvas canvas, Size size) {
    if (isDone) {
      final paint = Paint()..color = kPrimary;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        paint,
      );
    } else if (isHalfFilled) {
      final paint = Paint()
        ..color = kPrimary
        ..style = PaintingStyle.fill;
      final path = Path();
      path.moveTo(size.width / 2, size.height / 2);
      path.addArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        -math.pi / 2,
        math.pi,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
