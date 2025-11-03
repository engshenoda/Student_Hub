import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _postsCol = FirebaseFirestore.instance.collection('posts');


class PostRepository {
  final PostService service;
  PostRepository(this.service);

  Stream<List<Post>> watchPosts() => service.postsStream();

  Future<void> createPost({required Post post, File? imageFile}) => service.addPost(post: post, imageFile: imageFile);

  Future<void> updatePost({required String postId, required Map<String, dynamic> updates, File? newImage}) =>
      service.editPost(postId: postId, updateData: updates, newImage: newImage);

  Future<void> removePost(String postId) => service.deletePost(postId);

  Future<void> toggleLike(String postId, String userId) => service.toggleLike(postId, userId);

  Future<void> addComment(String postId, String userId, String userName, String text) =>
      service.addComment(postId, userId, userName, text);



// ✅ Like / Unlike Comment
 Future<void> toggleCommentLike(String postId, String commentId, String userId) =>
      service.toggleCommentLike(postId, commentId, userId);



      

       Stream<List<CommentModel>> watchComments(String postId) =>
      service.getComments(postId);

      Future<void> repostPost({
  required Post originalPost,
  required String userId,
  required String userName,
  String? userAvatar,
  String? caption,
}) =>
    service.repostPost(
      originalPost: originalPost,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      caption: caption,
    );

}
