import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';



class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.0)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.kDarkTeal),
            onPressed: () {
             
            },
          ),
        ],
      ),
    );
  }
}