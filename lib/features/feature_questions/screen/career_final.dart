import 'package:flutter/material.dart';
import 'package:sapp/screen/Docs_Screen.dart';

const Color kPrimary = Color(0xFF00B894);

class CareerPreferenceScreen extends StatelessWidget {
  const CareerPreferenceScreen({Key? key}) : super(key: key);

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
                  _buildStep("Profile", true),
                  _buildStep("Career Preference", true),
                  _buildStep("Docs", false),
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
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(14)),
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
                        "E-Commerce, FinTech, Consulting, Food And Beverage",
                        style: TextStyle(
                          fontSize: rw(14),
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const Icon(Icons.close, color: Colors.grey),
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
                children: [
                  _buildTag(
                      "E-Commerce, FinTech, Consulting, Food And Beverage", true),
                  _buildTag("3D Design", false),
                  _buildTag("Arts & Creative Design", false),
                  _buildTag("Associate Product Manager", false),
                ],
              ),
              SizedBox(height: rh(220)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DocsScreen(),
                          ),
                        );
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

  Widget _buildStep(String title, bool isDone) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isDone ? kPrimary : Colors.grey.shade300,
          child: Icon(
            isDone ? Icons.check : Icons.circle_outlined,
            color: isDone ? Colors.white : Colors.grey,
            size: 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDone ? kPrimary : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, bool selected) {
    return Container(
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
          if (!selected) const SizedBox(width: 6),
          if (!selected)
            const Icon(Icons.add, size: 16, color: Colors.black54),
        ],
      ),
    );
  }
}