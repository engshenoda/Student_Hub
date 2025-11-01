import 'package:flutter/material.dart';
import 'package:linkedin/features/home/presentation/screens/post.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.teal, size: 26),
          Icon(Icons.comment_rounded, color: Colors.teal, size: 26),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPost()),
              );
            },
            icon: Icon(Icons.add_box_outlined, size: 26),
            color: Colors.teal,
          ),
          Icon(Icons.article_outlined, color: Colors.teal, size: 26),
          Icon(Icons.person_outline, color: Colors.teal, size: 26),
        ],
      ),
    );
  }
}
