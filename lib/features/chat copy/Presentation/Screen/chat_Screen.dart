import 'package:flutter/material.dart';
import 'package:linkedin/core/constants/constants.dart';
import 'package:linkedin/features/chat%20copy/Presentation/widgets/chats_list_screen.dart';



class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat ',
      theme: ThemeData(
        primaryColor: kDarkTeal,
        colorScheme: ColorScheme.fromSeed(seedColor: kDarkTeal),
        useMaterial3: true,
      ),
      home: const ChatsListScreen(),
    );
  }
}