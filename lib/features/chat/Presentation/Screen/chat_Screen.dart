import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/chat/Presentation/widget/chats_list_screen.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat ',
      theme: ThemeData(
        primaryColor: AppColors.kDarkTeal,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kDarkTeal),
        useMaterial3: true,
      ),
      home: const ChatsListScreen(),
    );
  }
}
