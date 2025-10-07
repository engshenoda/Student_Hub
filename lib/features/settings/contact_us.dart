import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FDFB),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Terms & conditions",
          style: TextStyle(
            color: Color(0xFF006E59),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAAE7DB), Color(0xFFFBF9FC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF006E59)),
          onPressed: () => context.pop('/settings.dart'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text(
            "Or Contact On",
            style: TextStyle(
              color: Color(0xFF006E59),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  GoRouter.of(context).go('');
                },
                icon: Icon(FontAwesomeIcons.google),
                color: Colors.red,
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {
                  GoRouter.of(context).go('');
                },
                icon: Icon(Icons.sms, color: Colors.blue),
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {
                  GoRouter.of(context).go('');
                },
                icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Gmail",
                style: TextStyle(
                  color: Color(0xFF006E59),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "SMS",
                style: TextStyle(
                  color: Color(0xFF006E59),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "Whatsapp",
                style: TextStyle(
                  color: Color(0xFF006E59),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
