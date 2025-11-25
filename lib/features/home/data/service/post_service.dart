// features/home/data/service/post_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';

class PostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addPost(PostModel post) async {
  try {
    final docRef = post.id.isEmpty
        ? _firestore.collection('posts').doc()
        : _firestore.collection('posts').doc(post.id);

    final postWithId = post.id.isEmpty ? post.copyWith(id: docRef.id) : post;
    
    // تأكد أن الـ Post يحفظ authorName و authorImage
    print('🎯 Saving post with author: ${postWithId.authorName}');
    print('🎯 Author image: ${postWithId.authorImage}');
    
    await docRef.set(postWithId.toJson());
    print('✅ Post saved successfully with author data');
  } catch (e) {
    throw Exception('❌ Failed to add post: $e');
  }
}
  Future<void> updatePost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).update(post.toJson());
    } catch (e) {
      throw Exception('❌ Failed to update post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw Exception('❌ Failed to delete post: $e');
    }
  }

  Stream<List<PostModel>> watchPosts() {
    try {
      return _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => PostModel.fromDocumentSnapshot(doc))
                .toList(),
          );
    } catch (e) {
      throw Exception('❌ Failed to fetch posts: $e');
    }
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      final commentRef = comment.id.isEmpty
          ? _firestore
                .collection('posts')
                .doc(postId)
                .collection('comments')
                .doc()
          : _firestore
                .collection('posts')
                .doc(postId)
                .collection('comments')
                .doc(comment.id);

      final commentWithId = comment.id.isEmpty
          ? comment.copyWith(id: commentRef.id)
          : comment;

      await commentRef.set(commentWithId.toJson());
    } catch (e) {
      throw Exception('❌ Failed to add comment: $e');
    }
  }

  Future<void> updateComment(String postId, CommentModel comment) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment.id)
          .update(comment.toJson());
    } catch (e) {
      throw Exception('❌ Failed to update comment: $e');
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      throw Exception('❌ Failed to delete comment: $e');
    }
  }

  Stream<List<CommentModel>> watchComments(String postId) {
    try {
      return _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => CommentModel.fromDocumentSnapshot(doc))
                .toList(),
          );
    } catch (e) {
      throw Exception('❌ Failed to fetch comments: $e');
    }
  }

  Future<void> toggleLike(String postId, String userId, bool isLiked) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likeCount': FieldValue.increment(isLiked ? -1 : 1),
        'likes': isLiked 
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to update like: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;
      return userDoc.data();
    } catch (e) {
      print('⚠️ Failed to fetch user info for $userId: $e');
      return null;
    }
  }
}