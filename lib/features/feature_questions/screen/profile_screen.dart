import 'package:flutter/material.dart';
import 'career_preference_screen.dart';
import 'package:go_router/go_router.dart';
const Color kPrimary = Color(0xFF00B894);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Container(height: 8, color: kPrimary, width: double.infinity),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: s(18), vertical: s(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StepHeader(scale: s),
                            SizedBox(height: s(12)),
                            Text(
                              'Your profile will be visible to top recruiters',
                              style: TextStyle(
                                  fontSize: s(20),
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: s(12)),
                            InfoRecommendationCard(scale: s),
                            SizedBox(height: s(18)),
                            ProfileField(
                              scale: s,
                              leading: Icons.person,
                              label: 'Full Name',
                              value: 'username',
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.chat,
                              label: 'WhatsApp Number',
                              value: '+20 1X XXX XXXX',
                              showTrailingEdit: true,
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.badge,
                              label: 'Most Recent Role & Company',
                              value: 'Junior Developer @ IT-Vikings',
                              showTrailingEdit: true,
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.school,
                              label: 'Bachelor Degree Entry Year',
                              value: '2022',
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.attach_money,
                              label: 'Minimum Base Salary',
                              value: 'Rp8,600,000',
                              showTrailingInfo: true,
                              showTrailingEdit: true,
                            ),
                            SizedBox(height: s(30)),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(context).maybePop(),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: s(16)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(s(28)),
                                      ),
                                      side: BorderSide(
                                          color: Colors.grey.shade300),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                          fontSize: s(16),
                                          color: Colors.grey[800]),
                                    ),
                                  ),
                                ),
                                SizedBox(width: s(12)),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CareerPreferenceScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: s(16)),
                                      backgroundColor: kPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(s(28)),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: s(16),
                                          fontWeight: FontWeight.w600),
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
            );
          },
        ),
      ),
    );
  }
}
class _StepHeader extends StatelessWidget {
  final double Function(double) scale;
  const _StepHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Row(
      children: [
        Column(
          children: [
            _StepCircle(label: 'Profile', filled: true, size: s(28)),
            SizedBox(height: s(6)),
            Text('Profile',
                style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
          ],
        ),
        Expanded(
          child: Container(
            height: s(1),
            margin: EdgeInsets.symmetric(horizontal: s(10)),
            color: Colors.grey.shade300,
          ),
        ),
        Column(
          children: [
            _StepCircle(label: 'Career', filled: false, size: s(28)),
            SizedBox(height: s(6)),
            Text('Career Preference',
                style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
          ],
        ),
        Expanded(
          child: Container(
            height: s(1),
            margin: EdgeInsets.symmetric(horizontal: s(10)),
            color: Colors.grey.shade300,
          ),
        ),
        Column(
          children: [
            _StepCircle(label: 'Docs', filled: false, size: s(28)),
            SizedBox(height: s(6)),
            Text('Docs',
                style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
          ],
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final bool filled;
  final String label;
  final double size;
  const _StepCircle(
      {required this.filled, required this.label, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? kPrimary : Colors.white,
        shape: BoxShape.circle,
        border:
            Border.all(color: filled ? kPrimary : Colors.grey.shade300, width: 2),
        boxShadow: filled
            ? [
                BoxShadow(
                    color: kPrimary.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ]
            : [],
      ),
      child: filled
          ? Icon(Icons.check, color: Colors.white, size: size * 0.6)
          : null,
    );
  }
}

class InfoRecommendationCard extends StatelessWidget {
  final double Function(double) scale;
  const InfoRecommendationCard({required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(s(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(s(12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              backgroundColor: kPrimary.withOpacity(0.12),
              child: Icon(Icons.info_outline, color: kPrimary)),
          SizedBox(width: s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Your minimum salary seems to be higher than the industry standard average, usually it will be around Rp8.600.000',
                    style: TextStyle(
                        fontSize: s(13),
                        height: 1.3,
                        color: Colors.grey[800])),
                SizedBox(height: s(8)),
                GestureDetector(
                    onTap: () {},
                    child: Text('Use recommendation',
                        style: TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: s(13)))),
              ],
            ),
          ),
          SizedBox(width: s(8)),
          InkWell(
              onTap: () {},
              child:
                  Icon(Icons.close, size: s(18), color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final double Function(double) scale;
  final IconData leading;
  final String label;
  final String value;
  final bool showTrailingEdit;
  final bool showTrailingInfo;

  const ProfileField({
    required this.scale,
    required this.leading,
    required this.label,
    required this.value,
    this.showTrailingEdit = false,
    this.showTrailingInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(s(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(s(12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: kPrimary.withOpacity(0.12),
              child: Icon(leading, color: kPrimary)),
          SizedBox(width: s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        TextStyle(fontSize: s(12), color: Colors.grey[600])),
                SizedBox(height: s(6)),
                Text(value,
                    style: TextStyle(
                        fontSize: s(15), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (showTrailingInfo) ...[
            Icon(Icons.info_outline, color: Colors.grey[500], size: s(20)),
            SizedBox(width: s(8)),
          ],
          if (showTrailingEdit)
            Icon(Icons.edit_outlined, color: Colors.grey[600], size: s(20)),
        ],
      ),
    );
  }
}