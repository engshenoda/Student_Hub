import 'package:flutter/material.dart';

import 'list_tile.dart';

class ListView2 extends StatefulWidget {
  const ListView2({super.key});

  @override
  State<ListView2> createState() => _ListView2State();
}

class _ListView2State extends State<ListView2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Card(
            color: Color(0xFFD9F4EF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile2(),
          );
        },
      ),
    );
  }
}
