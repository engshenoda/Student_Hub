import 'package:flutter/material.dart';

class ListTile2 extends StatefulWidget {
  const ListTile2({super.key});

  @override
  State<ListTile2> createState() => _ListTile2State();
}

class _ListTile2State extends State<ListTile2> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF00B894),
        child: Text("SJ", style: TextStyle(color: Colors.white)),
      ),
      title: const Text("Sarah Johnson sent you a message"),
      subtitle: const Text(
        "Senior Product Manager at TechCrop • 500+ connections",
      ),
      trailing: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(foregroundColor: const Color(0xFF00B894)),
        child: const Text("Connect"),
      ),
    );
  }
}
