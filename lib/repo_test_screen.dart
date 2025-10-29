import 'package:flutter/material.dart';
import 'package:linkedin/features/chat/data/repo/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RepoTestScreen extends StatelessWidget {
  RepoTestScreen({super.key});

  final ChatRepository repo = ChatRepository();

  Future<void> _testFirestore() async {
    try {
      // تجربة كتابة بسيطة في كولكشن test_repo
      await FirebaseFirestore.instance.collection('test_repo').add({
        'message': 'Hello from repo test!',
        'timestamp': DateTime.now().toString(),
      });
      print('✅ Firestore write successful');

      // تجربة استخدام دالة من الريبو نفسه
      await repo.createChat(participants: ['user1', 'user2']);
      print('✅ ChatRepository createChat() works fine');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repo Firebase Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _testFirestore();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم اختبار الاتصال بالفirebase ✅')),
            );
          },
          child: const Text('اختبر ربط Repository بالFirebase'),
        ),
      ),
    );
  }
}
