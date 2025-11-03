import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';

class AddPost extends StatefulWidget {
  final Post? existing;
  const AddPost({super.key, this.existing});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  
  final TextEditingController _controller = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.existing != null) {
  _controller.text = widget.existing!.text;
  if (widget.existing!.imageUrl != null) {
    _pickedImage = File(widget.existing!.imageUrl!);
  }
}

  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty && _pickedImage == null) return;

    setState(() => _isLoading = true);

    final cubit = context.read<PostCubit>();

  final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? 'guest_user';
    final currentUserName = currentUser?.displayName ?? 'Unknown User';


    if (widget.existing == null) {
      final post = Post(
        id: '',
        authorId: currentUserId, // TODO: replace with FirebaseAuth.uid
        authorName: currentUserName, // TODO: replace with Firebase user name
        authorAvatar: null,
        text: text,
        imageUrl: null,
        createdAt: DateTime.now(),
      );
      cubit.addPost(post: post, imageFile: _pickedImage);
    } else {
      cubit.editPost(
        postId: widget.existing!.id,
        updates: {'text': text},
        newImage: _pickedImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? 'guest_user';
    final currentUserName = currentUser?.displayName ?? 'Unknown User';
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostActionSuccess) {
          setState(() => _isLoading = false);
          GoRouter.of(context).pop();
        } else if (state is PostActionFailure) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
         
          body: SafeArea(
            child: Column(
              children: [
                // 🔹 Header Section (بنفس التصميم القديم)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB2DFDB), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        icon: const Icon(Icons.cancel_outlined,
                            size: 40, color: Colors.teal),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Post',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Profile Section
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi, $currentUserName",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.teal,
                                  ),
                                ),
                                const Text(
                                  "UI / UX Designer",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // 🔹 Text Field
                        TextField(
                          controller: _controller,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Share your thoughts...",
                            border: InputBorder.none,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // 🔹 Image Preview
                        if (_pickedImage != null)
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(_pickedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.white, size: 26),
                                  onPressed: () =>
                                      setState(() => _pickedImage = null),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),

                        // 🔹 Add Image Button
                        Row(
                          children: [
                            const Text(
                              "Add to your post",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
