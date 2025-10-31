import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/questions/Logic/cubit/cubit/career_role_cubit.dart';
import 'career_final.dart'; // Your final destination

const Color kPrimary = Color(0xFF00B894);

class CareerNextScreen extends StatefulWidget {
  const CareerNextScreen({Key? key}) : super(key: key);

  @override
  State<CareerNextScreen> createState() => _CareerNextScreenState();
}

class _CareerNextScreenState extends State<CareerNextScreen> {
  int selectedOption = -1;
  final List<String> options = [
    'Frontend Developer',
    'Backend Developer',
    'UI/UX Designer',
    'Data Scientist',
  ];

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

    return BlocProvider(
      create: (_) => CareerRoleCubit(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFFF7F7F9),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: s(18), vertical: s(10)),
                  child: Column(
                    children: [
                      Container(height: 8, color: kPrimary, width: double.infinity),
                      SizedBox(height: s(20)),
                      // Stepper
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _StepCircleWithLabel(
                                size: s(28),
                                isActive: true,
                                label: 'Profile',
                                scale: s,
                                hasCheck: true,
                                fillPercent: 1.0,
                              ),
                              Container(width: s(50), height: 2, color: Colors.grey[300]),
                              _StepCircleWithLabel(
                                size: s(28),
                                isActive: true,
                                label: 'Career',
                                scale: s,
                                hasCheck: false,
                                fillPercent: 0.70,
                              ),
                              Container(width: s(50), height: 2, color: Colors.grey[300]),
                              _StepCircleWithLabel(
                                size: s(28),
                                isActive: false,
                                label: 'Docs',
                                scale: s,
                                hasCheck: false,
                                fillPercent: 0.0,
                              ),
                            ],
                          ),
                          SizedBox(height: s(8)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: s(80),
                                child: Text('Profile', textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: s(12),
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  )),
                              ),
                              SizedBox(width: s(50)),
                              SizedBox(
                                width: s(80),
                                child: Text('Career Preference', textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: s(12),
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  )),
                              ),
                              SizedBox(width: s(50)),
                              SizedBox(
                                width: s(80),
                                child: Text('Docs', textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: s(12),
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: s(28)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'What kind of roles are you open to?',
                          style: TextStyle(
                            fontSize: s(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: s(16)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: s(16), horizontal: s(14)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(s(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            )
                          ],
                          border: Border.all(color: kPrimary, width: 1.5),
                        ),
                        child: Text(
                          selectedOption == -1
                              ? 'No selection yet'
                              : options[selectedOption],
                          style: TextStyle(
                            fontSize: s(16),
                            fontWeight: FontWeight.w600,
                            color: selectedOption == -1
                                ? Colors.grey[600]
                                : kPrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: s(26)),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: s(14),
                            crossAxisSpacing: s(14),
                            childAspectRatio: 1.9,
                          ),
                          itemBuilder: (context, index) {
                            final isSelected = selectedOption == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedOption = index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                decoration: BoxDecoration(
                                  color: isSelected ? kPrimary : Colors.white,
                                  borderRadius: BorderRadius.circular(s(14)),
                                  border: Border.all(
                                    color: isSelected
                                        ? kPrimary
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    options[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: s(14),
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: s(20),
                          bottom: s(26),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.pop(),
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
                                onPressed: selectedOption != -1
                                    ? () async {
                                        final userId = FirebaseAuth.instance.currentUser?.uid ?? "demo_user";
                                        final cubit = context.read<CareerRoleCubit>();
                                        await cubit.updateCareerRole(userId, options[selectedOption]);
                                        if (!mounted) return;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const CarerrScreenFinal()),
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: s(16)),
                                  backgroundColor: kPrimary,
                                  foregroundColor: Colors.white,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepCircleWithLabel extends StatelessWidget {
  final double size;
  final bool isActive;
  final String label;
  final double Function(double) scale;
  final bool hasCheck;
  final double fillPercent;

  const _StepCircleWithLabel({
    required this.size,
    required this.isActive,
    required this.label,
    required this.scale,
    this.hasCheck = false,
    this.fillPercent = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? kPrimary : Colors.grey[300]!,
                  width: 2,
                ),
              ),
            ),
            if (fillPercent > 0)
              ClipOval(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: fillPercent.clamp(0.0, 1.0),
                  child: Container(
                    width: size,
                    height: size,
                    color: kPrimary,
                  ),
                ),
              ),
            if (hasCheck)
              Icon(
                Icons.check,
                color: Colors.white,
                size: size * 0.6,
              ),
          ],
        ),
      ],
    );
  }
}
