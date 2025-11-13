import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/features/questions/Logic/cubit/user_cubit.dart';
import 'package:linkedin/features/questions/Logic/cubit/user_state.dart';

import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';

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
  final _formKey = GlobalKey<FormState>();

  String? _selectedGender;
  final _whatsappCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();
  final _birthdayCtrl = TextEditingController();
  bool _isClient = true;
  bool _initialized = false;

  @override
  void dispose() {
    _whatsappCtrl.dispose();
    _jobTitleCtrl.dispose();
    _birthdayCtrl.dispose();
    super.dispose();
  }

  double responsive(BuildContext context, double value) {
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide;
    final longest = size.longestSide;
    final scale = (shortest / 390 + longest / 844) / 2;
    return value * scale.clamp(0.7, 1.4);
  }

  Future<void> _selectBirthday() async {
    final initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _birthdayCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = (double px) => responsive(context, px);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is UserError) return Center(child: Text(state.message));
            if (state is! UserLoaded) return const SizedBox();

            final user = state.user;
            final cubit = context.read<UserCubit>();

            if (!_initialized) {
              _selectedGender = user.gender.isNotEmpty ? user.gender : null;
              _whatsappCtrl.text = user.whatsapp.toString();
              _jobTitleCtrl.text = user.jobTitle;
              _birthdayCtrl.text = user.birthday != null
                  ? "${user.birthday!.day}/${user.birthday!.month}/${user.birthday!.year}"
                  : '';
              _isClient = user.isClient;
              _initialized = true;
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: s(18),
                    vertical: s(10),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 8,
                          color: AppColors.primary,
                          width: double.infinity,
                        ),
                        SizedBox(height: s(12)),
                        Text(
                          'Your profile will be visible to top recruiters',
                          style: TextStyle(
                            fontSize: s(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: s(18)),

                        // Gender
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(s(8)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: s(12),
                              horizontal: s(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Select gender'
                              : null,
                        ),
                        SizedBox(height: s(12)),

                        // WhatsApp
                        ProfileField(
                          scale: s,
                          leading: Icons.chat,
                          label: 'WhatsApp Number',
                          controller: _whatsappCtrl,
                          showTrailingEdit: true,
                          validator: (val) {
                            if (val == null || val.isEmpty)
                              return 'Enter WhatsApp number';
                            if (!RegExp(r'^\d{8,15}$').hasMatch(val))
                              return 'Invalid number';
                            return null;
                          },
                        ),
                        SizedBox(height: s(12)),

                        // Job Title
                        ProfileField(
                          scale: s,
                          leading: Icons.badge,
                          label: 'Job Title',
                          controller: _jobTitleCtrl,
                          showTrailingEdit: true,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter job title'
                              : null,
                        ),
                        SizedBox(height: s(12)),

                        // Birthday
                        GestureDetector(
                          onTap: _selectBirthday,
                          child: AbsorbPointer(
                            child: ProfileField(
                              scale: s,
                              leading: Icons.cake,
                              label: 'Birthday',
                              controller: _birthdayCtrl,
                              showTrailingEdit: true,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return 'Select birthday';
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: s(12)),

                        // Client / Employee
                        Row(
                          children: [
                            Text(
                              'Client or Employee',
                              style: TextStyle(fontSize: s(14)),
                            ),
                            SizedBox(width: s(12)),
                            Switch(
                              value: _isClient,
                              onChanged: (val) =>
                                  setState(() => _isClient = val),
                            ),
                            Text(
                              _isClient ? 'Client' : 'Employee',
                              style: TextStyle(fontSize: s(14)),
                            ),
                          ],
                        ),
                        SizedBox(height: s(30)),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: s(16),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(s(28)),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
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
                                  if (_formKey.currentState!.validate()) {
                                    await cubit.updateUserField(
                                      userId: widget.userId,
                                      field: 'gender',
                                      newValue: _selectedGender,
                                    );
                                    await cubit.updateUserField(
                                      userId: widget.userId,
                                      field: 'whatsapp',
                                      newValue:
                                          int.tryParse(_whatsappCtrl.text) ?? 0,
                                    );
                                    await cubit.updateUserField(
                                      userId: widget.userId,
                                      field: 'jobTitle',
                                      newValue: _jobTitleCtrl.text,
                                    );
                                    if (_birthdayCtrl.text.isNotEmpty) {
                                      final parts = _birthdayCtrl.text.split(
                                        '/',
                                      );
                                      final dt = DateTime(
                                        int.parse(parts[2]),
                                        int.parse(parts[1]),
                                        int.parse(parts[0]),
                                      );
                                      await cubit.updateUserField(
                                        userId: widget.userId,
                                        field: 'birthday',
                                        newValue: dt,
                                      );
                                    }
                                    await cubit.updateUserField(
                                      userId: widget.userId,
                                      field: 'isClient',
                                      newValue: _isClient,
                                    );

                                    if (!mounted) return;
                                    GoRouter.of(context).push(Routes.home);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: s(16),
                                  ),
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(s(28)),
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
              ),
            );
          },
        ),
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
  final String? Function(String?)? validator;

  const ProfileField({
    super.key,
    required this.scale,
    required this.leading,
    required this.label,
    required this.controller,
    this.showTrailingEdit = false,
    this.validator,
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
            child: TextFormField(
              controller: widget.controller,
              readOnly: !_isEditing,
              validator: widget.validator,
              style: TextStyle(fontSize: s(15), fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: s(8),
                  horizontal: s(8),
                ),
                border: _isEditing
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(s(8)),
                      )
                    : InputBorder.none,
              ),
              onFieldSubmitted: (_) => setState(() => _isEditing = false),
            ),
          ),
          if (widget.showTrailingEdit)
            InkWell(
              onTap: () => setState(() => _isEditing = !_isEditing),
              child: Icon(
                _isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                color: _isEditing ? AppColors.primary : Colors.grey[600],
                size: s(20),
              ),
            ),
        ],
      ),
    );
  }
}
