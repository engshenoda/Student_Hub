import 'package:flutter/material.dart';
import 'package:linkedin/features/questions/data/Docs_Screen.dart';
import 'package:linkedin/features/questions/data/career_next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color kPrimary = Color(0xFF00B894);

class CarerrScreenFinal extends StatefulWidget {
  const CarerrScreenFinal({Key? key}) : super(key: key);

  @override
  State<CarerrScreenFinal> createState() => _CarerrScreenFinalState();
}

class _CarerrScreenFinalState extends State<CarerrScreenFinal> {
  final List<String> allTags = [
    "E-Commerce, FinTech, Consulting, Food And Beverage",
    "3D Design",
    "Arts & Creative Design",
    "Associate Product Manager",
  ];

  final Set<String> selectedTags = {
    "E-Commerce, FinTech, Consulting, Food And Beverage",
  };

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStep("Profile", true, false),
                  _buildStep("Career Preference", true, false),
                  _buildStep("Docs", false, true),
                ],
              ),
              SizedBox(height: rh(40)),
              Text(
                "What industry do you prefer to work in?",
                style: TextStyle(
                  fontSize: rw(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              SizedBox(height: rh(24)),
              if (selectedTags.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(14)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.apartment_rounded, color: kPrimary),
                      SizedBox(width: rw(8)),
                      Expanded(
                        child: Text(
                          selectedTags.join(", "),
                          style: TextStyle(
                            fontSize: rw(14),
                            color: Colors.black87,
                            height: 1.4,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTags.clear();
                          });
                        },
                        child: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: rh(30)),
              Text(
                "Suggestions",
                style: TextStyle(
                  fontSize: rw(16),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: rh(12)),
              Wrap(
                spacing: rw(10),
                runSpacing: rh(10),
                children: allTags
                    .map(
                      (tag) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedTags.contains(tag)) {
                              selectedTags.remove(tag);
                            } else {
                              selectedTags.add(tag);
                            }
                          });
                        },
                        child: _buildTag(tag, selectedTags.contains(tag)),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: rh(220)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CareerNextScreen(),
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
                      onPressed: () async {
                        if (selectedTags.isNotEmpty) {
                          final userId = FirebaseAuth.instance.currentUser?.uid ?? "demo_user";
                          await FirebaseFirestore.instance
                              .collection("career_industries")
                              .doc(userId)
                              .set({
                                "selectedTags": selectedTags.toList(),
                                "lastUpdated": FieldValue.serverTimestamp(),
                              }, SetOptions(merge: true));
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DocsScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please select at least one industry before continuing."),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
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

  Widget _buildStep(String title, bool isDone, bool isOutlined) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOutlined
                ? Colors.white
                : (isDone ? kPrimary : Colors.grey.shade300),
            border: isOutlined ? Border.all(color: kPrimary, width: 2) : null,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: (isDone || isOutlined) ? kPrimary : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? kPrimary.withOpacity(0.15) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? kPrimary : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? kPrimary : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            selected ? Icons.check : Icons.add,
            size: 16,
            color: selected ? kPrimary : Colors.black54,
          ),
        ],
      ),
    );
  }
}
