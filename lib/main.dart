import 'package:flutter/material.dart';
import 'package:linkedin/features/home/presentation/screens/comments.dart';
import 'package:linkedin/features/home/presentation/screens/home_screen.dart';
import 'package:linkedin/features/home/presentation/screens/post.dart';
import 'package:linkedin/features/home/presentation/screens/repost.dart';
import 'package:linkedin/features/home/presentation/widgets/home_header.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social App UI',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(),
      routes: {
        '/comments': (context) => const Comments(),
        '/post': (context) => const Post(),
        '/repost': (context) => const Repost(),
      },
    );
  }
}
