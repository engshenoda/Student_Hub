import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linkedin/firebase_options.dart';
import 'package:linkedin/student_hub.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'repo_test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const StudentHub());
}