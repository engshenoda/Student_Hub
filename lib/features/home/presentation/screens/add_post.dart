// features/home/presentation/screens/add_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _contentCtrl = TextEditingController();
  String? _imageUrl; // placeholder for future upload

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post', style: TextStyle(color: Colors.teal)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () async {
              final text = _contentCtrl.text.trim();
              if (text.isEmpty) return;
              final newPost = PostModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                authorId: currentUser?.uid ?? '',
                content: text,
                media: _imageUrl != null ? [MediaItem(url: _imageUrl!, type: 'image')] : [],
                createdAt: DateTime.now(),
                updatedAt: null,
                likeCount: 0,
                commentCount: 0,
                repostCount: 0,
                isRepost: false,
                originalPostId: null,
                linkPreview: null,
              );
              await context.read<PostCubit>().addPost(newPost);
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentCtrl,
              maxLines: 6,
              decoration: const InputDecoration.collapsed(hintText: 'What\'s happening?'),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // implement image picker/upload later
                  },
                  icon: const Icon(Icons.image_outlined, color: Colors.grey),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.link_outlined, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
