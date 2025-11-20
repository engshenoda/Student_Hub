// features/home/presentation/screens/add_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _contentCtrl = TextEditingController();
  final TextEditingController _linkCtrl = TextEditingController();
  final List<String> _links = [];

  void _addLink() {
    final link = _linkCtrl.text.trim();
    if (link.isNotEmpty && _isValidUrl(link)) {
      setState(() {
        _links.add(link);
        _linkCtrl.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
    }
  }

  bool _isValidUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  void _removeLink(int index) {
    setState(() {
      _links.removeAt(index);
    });
  }

  Future<void> _createPost() async {
    final text = _contentCtrl.text.trim();
    if (text.isEmpty && _links.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add some content or links')),
      );
      return;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // جلب بيانات المستخدم من Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      
      final userData = userDoc.data() ?? {};
      final userName = userData['name'] ?? 'User';
      final userImage = userData['photoUrl'] ?? userData['profileImage'];

      // أنشئ الـ Post مع authorName و authorImage ✅
      final newPost = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: currentUser.uid,
        authorName: userName, // ✅ سيظهر الاسم الحقيقي
        authorImage: userImage, // ✅ سيظهر الصورة الحقيقية
        content: text,
        links: _links,
        createdAt: DateTime.now(),
        likeCount: 0,
        commentCount: 0,
        repostCount: 0,
        isRepost: false,
        likes: [],
      );

      await context.read<PostCubit>().addPost(newPost);
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post', style: TextStyle(color: Colors.teal)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: _createPost,
            child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _contentCtrl,
                      maxLines: 6,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'What\'s happening?'
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // عرض الروابط المضافة
                    if (_links.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Added Links:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ..._links.asMap().entries.map((entry) {
                            final index = entry.key;
                            final link = entry.value;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(Icons.link, color: Colors.teal),
                                title: Text(link, overflow: TextOverflow.ellipsis),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeLink(index),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // إضافة روابط جديدة
                    TextField(
                      controller: _linkCtrl,
                      decoration: InputDecoration(
                        hintText: 'Add a link...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add_link),
                          onPressed: _addLink,
                        ),
                      ),
                      onSubmitted: (_) => _addLink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}