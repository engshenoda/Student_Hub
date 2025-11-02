import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/questions/Logic/cubit/profile_cubit.dart';
import 'package:linkedin/features/questions/Logic/cubit/profile_state.dart';

 

class ProfileQScreen extends StatelessWidget {
  const ProfileQScreen({super.key});

  Future<void> _initFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Firebase init error: ${snapshot.error}')),
          );
        }
        final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo_user';
        return BlocProvider(
          create: (_) => UserCubit()..listenToUser(userId),
          child: _ProfileQBody(userId: userId),
        );
      },
    );
  }
}

class _ProfileQBody extends StatefulWidget {
  final String userId;
  const _ProfileQBody({required this.userId});

  @override
  State<_ProfileQBody> createState() => _ProfileQBodyState();
}

class _ProfileQBodyState extends State<_ProfileQBody> {
  final _fullNameCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _degreeYearCtrl = TextEditingController();
  final _minSalaryCtrl = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _whatsappCtrl.dispose();
    _roleCtrl.dispose();
    _degreeYearCtrl.dispose();
    _minSalaryCtrl.dispose();
    super.dispose();
  }

  double responsive(BuildContext context, double value) {
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide;
    final longest = size.longestSide;
    final scale = (shortest / 390 + longest / 844) / 2;
    return value * scale.clamp(0.7, 1.4);
  }

  @override
  Widget build(BuildContext context) {
    final s = (double px) => responsive(context, px);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: BlocBuilder<UserCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserError) {
              return Center(child: Text(state.message));
            }
            if (state is! UserLoaded) return const SizedBox();

            final user = state.user;
            final cubit = context.read<UserCubit>();

            if (!_initialized) {
              _fullNameCtrl.text = user.fullName;
              _whatsappCtrl.text = user.whatsapp.toString();
              _roleCtrl.text = user.role;
              _degreeYearCtrl.text = user.degreeYear;
              _minSalaryCtrl.text = user.minSalary.toStringAsFixed(0);
              _initialized = true;
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Container(height: 8, color: AppColors.primary, width: double.infinity),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: s(18),
                          vertical: s(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // _StepHeader(scale: s),
                            SizedBox(height: s(12)),
                            Text(
                              'Your profile will be visible to top recruiters',
                              style: TextStyle(
                                fontSize: s(20),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: s(12)),
                            InfoRecommendationCard(
                              scale: s,
                              cubit: cubit,
                              userId: widget.userId,
                            ),
                            SizedBox(height: s(18)),
                            ProfileField(
                              scale: s,
                              leading: Icons.person,
                              label: 'Full Name',
                              controller: _fullNameCtrl,
                              showTrailingEdit: true,
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.chat,
                              label: 'WhatsApp Number',
                              controller: _whatsappCtrl,
                              showTrailingEdit: true,
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.badge,
                              label: 'Most Recent Role & Company',
                              controller: _roleCtrl,
                              showTrailingEdit: true,
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.school,
                              label: 'Bachelor Degree Entry Year',
                              controller: _degreeYearCtrl,
                              showTrailingEdit: true,
                            ),
                            SizedBox(height: s(12)),
                            ProfileField(
                              scale: s,
                              leading: Icons.attach_money,
                              label: 'Minimum Base Salary',
                              controller: _minSalaryCtrl,
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: s(16)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(s(28)),
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                        fontSize: s(16),
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: s(12)),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await cubit.updateUserField(
                                          userId: widget.userId,
                                          field: 'fullName',
                                          newValue: _fullNameCtrl.text);
                                      await cubit.updateUserField(
                                          userId: widget.userId,
                                          field: 'whatsapp',
                                          newValue:
                                              int.tryParse(_whatsappCtrl.text) ??
                                                  0);
                                      await cubit.updateUserField(
                                          userId: widget.userId,
                                          field: 'role',
                                          newValue: _roleCtrl.text);
                                      await cubit.updateUserField(
                                          userId: widget.userId,
                                          field: 'degreeYear',
                                          newValue: _degreeYearCtrl.text);
                                      await cubit.updateUserField(
                                          userId: widget.userId,
                                          field: 'minSalary',
                                          newValue: double.tryParse(
                                                  _minSalaryCtrl.text) ??
                                              0.0);

                                      if (!mounted) return;
                                      GoRouter.of(context).push(Routes.Home);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: s(16)),
                                      backgroundColor: AppColors.primary,
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
                                        fontWeight: FontWeight.w600,
                                      ),
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

// class _StepHeader extends StatelessWidget {
//   final double Function(double) scale;
//   const _StepHeader({required this.scale});
//   @override
//   Widget build(BuildContext context) {
//     final s = scale;
//     return Row(
//       children: [
//         _Step(label: 'Profile', filled: true, s: s),
//         _Connector(s),
//         _Step(label: 'Career', filled: false, s: s),
//         _Connector(s),
//         _Step(label: 'Docs', filled: false, s: s),
//       ],
//     );
//   }
//   Widget _Connector(double Function(double) s) => Expanded(
//         child: Container(
//           height: s(1),
//           margin: EdgeInsets.symmetric(horizontal: s(10)),
//           color: Colors.grey.shade300,
//         ),
//       );
// }

// class _Step extends StatelessWidget {
//   final String label;
//   final bool filled;
//   final double Function(double) s;
//   const _Step({required this.label, required this.filled, required this.s});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: s(28),
//           height: s(28),
//           decoration: BoxDecoration(
//             color: filled ? AppColors.primary : Colors.white,
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: filled ? AppColors.primary : Colors.grey.shade300,
//               width: 2,
//             ),
//             boxShadow: filled
//                 ? [
//                     BoxShadow(
//                       color: AppColors.primary.withOpacity(0.18),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: filled
//               ? Icon(Icons.check, color: Colors.white, size: s(16))
//               : null,
//         ),
//         SizedBox(height: s(6)),
//         Text(
//           label,
//           style: TextStyle(fontSize: s(12), color: Colors.grey[700]),
//         ),
//       ],
//     );
//   }
// }

class InfoRecommendationCard extends StatelessWidget {
  final double Function(double) scale;
  final UserCubit cubit;
  final String userId;

  const InfoRecommendationCard({super.key, 
    required this.scale,
    required this.cubit,
    required this.userId,
  });

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
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Icon(Icons.info_outline, color: AppColors.primary),
          ),
          SizedBox(width: s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your minimum salary seems higher than average, usually around \$8600',
                  style: TextStyle(
                    fontSize: s(13),
                    height: 1.3,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: s(8)),
                GestureDetector(
                  onTap: () => cubit.updateUserField(
                    userId: userId,
                    field: 'minSalary',
                    newValue: 8600,
                  ),
                  child: Text(
                    'Use recommendation',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: s(13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Icon(Icons.close, size: s(18), color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class ProfileField extends StatefulWidget {
  final double Function(double) scale;
  final IconData leading;
  final String label;
  final TextEditingController controller;
  final bool showTrailingEdit;
  final bool showTrailingInfo;

  const ProfileField({
    super.key,
    required this.scale,
    required this.leading,
    required this.label,
    required this.controller,
    this.showTrailingEdit = false,
    this.showTrailingInfo = false,
  });

  @override
  State<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.scale;
    return Container(
      padding: EdgeInsets.all(s(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(s(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Icon(widget.leading, color: AppColors.primary),
          ),
          SizedBox(width: s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style:
                      TextStyle(fontSize: s(12), color: Colors.grey[600]),
                ),
                SizedBox(height: s(6)),
                _isEditing
                    ? TextField(
                        controller: widget.controller,
                        autofocus: true,
                        style: TextStyle(
                          fontSize: s(15),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: s(4),
                            horizontal: s(8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(s(8)),
                            borderSide:
                                const BorderSide(color: AppColors.primary, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(s(8)),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => setState(() => _isEditing = false),
                      )
                    : Text(
                        widget.controller.text,
                        style: TextStyle(
                          fontSize: s(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
          ),
          if (widget.showTrailingInfo)
            Padding(
              padding: EdgeInsets.only(left: s(8)),
              child: Icon(
                Icons.info_outline,
                color: Colors.grey[500],
                size: s(20),
              ),
            ),
          if (widget.showTrailingEdit)
            InkWell(
              onTap: () => setState(() => _isEditing = !_isEditing),
              child: Icon(
                _isEditing
                    ? Icons.check_circle_outline
                    : Icons.edit_outlined,
                color: _isEditing ? AppColors.primary : Colors.grey[600],
                size: s(20),
              ),
            ),
        ],
      ),
    );
  }
}
