import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// <<<<<<< feature/profile-logic
// import 'package:go_router/go_router.dart';
// import 'package:linkedin/core/routes/route.dart';
// =======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';

import 'career_final.dart';
import 'profile_screen.dart';

const Color kPrimary = Color(0xFF00B894);

class DocsScreen extends StatefulWidget {
  const DocsScreen({Key? key}) : super(key: key);

  @override
  State<DocsScreen> createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  String? cvFileName;
  String? portfolioFileName;
  final List<_PortfolioItem> portfolioItems = [_PortfolioItem()];

  bool _isValidUrl(String url) {
    final pattern = r'^(https?:\/\/)[^\s/$.?#].[^\s]*$';
    return RegExp(pattern, caseSensitive: false).hasMatch(url.trim());
  }

  Future<void> _pickFile({required bool isCV}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isCV)
          cvFileName = result.files.single.name;
        else
          portfolioFileName = result.files.single.name;
      });
    }
  }

  void _addPortfolioField() =>
      setState(() => portfolioItems.add(_PortfolioItem()));

  bool _validateInputs() {
    bool allValid = true;
    for (final item in portfolioItems) {
      final text = item.controller.text;
      item.isValid = text.isEmpty ? true : _isValidUrl(text);
      if (!item.isValid) allValid = false;
    }
// <<<<<<< feature/profile-logic

//     final hasValidLink = portfolioItems.any(
//       (i) => _isValidUrl(i.controller.text),
//     );

// =======
    final hasValidLink = portfolioItems.any((i) => _isValidUrl(i.controller.text));

    if (cvFileName == null) {
      _showError("Please upload your CV file.");
      return false;
    }
    if (!hasValidLink && portfolioFileName == null) {
      _showError(
        "Please add at least one portfolio link or upload a PDF file.",
      );
      return false;
    }
    if (!allValid) {
      _showError("Please check your portfolio links.");
      return false;
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  void _onNextPressed() async {
    if (_validateInputs()) {
// <<<<<<< feature/profile-logic
//       GoRouter.of(context).go(Routes.Home);
// =======
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "demo_user";
      final Map<String, dynamic> data = {
        "cvFileName": cvFileName,
        "portfolioFileName": portfolioFileName,
        "portfolioLinks": portfolioItems
            .map((item) => item.controller.text)
            .where((text) => text.isNotEmpty)
            .toList(),
        "lastUpdated": FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance
          .collection("user_docs")
          .doc(userId)
          .set(data, SetOptions(merge: true));
      if (!mounted) return;
      context.go(Routes.Home); // GoRouter navigation to home screen

    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double rw(double v) => size.width * (v / 390);
    double rh(double v) => size.height * (v / 844);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: rw(24), vertical: rh(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepsHeader(),
              SizedBox(height: rh(40)),
              const _IntroText(),
              SizedBox(height: rh(32)),
              UploadCard(
                title: "Upload your CV in PDF (max. 5 MB)",
                fileName: cvFileName,
                onTap: () => _pickFile(isCV: true),
              ),
              SizedBox(height: rh(30)),
              const SectionTitle("Portfolio (optional)"),
              SizedBox(height: rh(10)),
              Column(
                children: List.generate(portfolioItems.length, (i) {
                  final item = portfolioItems[i];
                  return Padding(
                    padding: EdgeInsets.only(bottom: rh(12)),
                    child: TextField(
                      controller: item.controller,
                      onChanged: (v) => setState(() {
                        item.isValid = v.isEmpty ? true : _isValidUrl(v);
                      }),
                      decoration: InputDecoration(
                        labelText: "URL Link",
                        hintText: "https://",
                        errorText: item.isValid ? null : "Invalid link",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: kPrimary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              TextButton.icon(
                onPressed: _addPortfolioField,
                icon: const Icon(Icons.add, color: kPrimary),
                label: const Text(
                  "Add Another Link",
                  style: TextStyle(color: kPrimary),
                ),
              ),
              SizedBox(height: rh(20)),
              UploadCard(
                title: "Or upload your portfolio as PDF",
                fileName: portfolioFileName,
                onTap: () => _pickFile(isCV: false),
              ),
              SizedBox(height: rh(100)),
              Row(
                children: [
                  Expanded(
                    child: _CustomButton(
                      text: "Back",
                      outlined: true,
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CarerrScreenFinal(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: rw(12)),
                  Expanded(
                    child: _CustomButton(
                      text: "Next",
                      onPressed: _onNextPressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================
// 🔹 Widgets & Helpers
// =======================

class _PortfolioItem {
  final TextEditingController controller = TextEditingController();
  bool isValid = true;
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Get your CV analyzed & receive job offers",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.3,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "There is no perfect CV, but uploading them now will allow you to get exclusive job offers. Plus, you can always reupload anytime!",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}

class UploadCard extends StatelessWidget {
  final String title;
  final String? fileName;
  final VoidCallback onTap;

  const UploadCard({
    required this.title,
    required this.fileName,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasFile = fileName != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: hasFile ? kPrimary.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasFile ? kPrimary : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                  color: hasFile ? kPrimary : Colors.black54,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  hasFile ? "Uploaded" : "Add File",
                  style: TextStyle(
                    color: hasFile ? kPrimary : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (hasFile)
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(Icons.check_circle, color: kPrimary, size: 18),
                  ),
              ],
            ),
          ),
        ),
        if (hasFile)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              fileName!,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ),
      ],
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String text;
  final bool outlined;
  final VoidCallback onPressed;

  const _CustomButton({
    required this.text,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double rw(double v) => size.width * (v / 390);
    double rh(double v) => size.height * (v / 844);

    final baseStyle = ElevatedButton.styleFrom(
      backgroundColor: outlined ? Colors.white : kPrimary,
      padding: EdgeInsets.symmetric(vertical: rh(16)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rw(28)),
        side: BorderSide(
          color: outlined ? Colors.grey.shade400 : kPrimary,
          width: 1.5,
        ),
      ),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: baseStyle,
      child: Text(
        text,
        style: TextStyle(
          color: outlined ? Colors.grey[800] : Colors.white,
          fontSize: rw(16),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class StepsHeader extends StatelessWidget {
  const StepsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        StepCircle(title: "Profile", isDone: true),
        StepCircle(title: "Career Preference", isDone: true),
        StepCircle(title: "Docs", isHalfFilled: true),
      ],
    );
  }
}

class StepCircle extends StatelessWidget {
  final String title;
  final bool isDone;
  final bool isHalfFilled;

  const StepCircle({
    required this.title,
    this.isDone = false,
    this.isHalfFilled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kPrimary, width: 2),
          ),
          child: ClipOval(
            child: CustomPaint(
              painter: _HalfCirclePainter(isDone, isHalfFilled),
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
}

class _HalfCirclePainter extends CustomPainter {
  final bool isDone;
  final bool isHalfFilled;

  _HalfCirclePainter(this.isDone, this.isHalfFilled);

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
      final paint = Paint()..color = kPrimary;
      final path = Path()
        ..moveTo(size.width / 2, size.height / 2)
        ..addArc(
          Rect.fromLTWH(0, 0, size.width, size.height),
          -math.pi / 2,
          math.pi,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
