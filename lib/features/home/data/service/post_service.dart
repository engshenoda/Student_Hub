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
      final postRef = _firestore.collection('posts').doc(postId);
      try {
        await _firestore.runTransaction((txn) async {
          // set comment document
          txn.set(commentRef, commentWithId.toJson());
          // increment post comment count
          txn.update(postRef, {'commentCount': FieldValue.increment(1)});
        });
      } catch (e) {
        throw Exception('❌ Failed to add comment: $e');
      }
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
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);
    final postRef = _firestore.collection('posts').doc(postId);
    try {
      await _firestore.runTransaction((txn) async {
        txn.delete(commentRef);
        txn.update(postRef, {'commentCount': FieldValue.increment(-1)});
      });
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
    final postRef = _firestore.collection('posts').doc(postId);
    try {
      await _firestore.runTransaction((txn) async {
        final snapshot = await txn.get(postRef);
        if (!snapshot.exists) throw Exception('Post not found');
        final current = (snapshot.data()?['likeCount'] as int?) ?? 0;
        final delta = isLiked
            ? 1
            : -1; // `isLiked` represents the new state (true == user now likes the post).
        final newCount = (current + delta) < 0
            ? 0
            : (current + delta); // Never allow negative counts.

        txn.update(postRef, {
          'likeCount': newCount,
          'likes': isLiked
              ? FieldValue.arrayUnion([userId])
              : FieldValue.arrayRemove([userId]),
        });
      });
    } catch (e) {
      throw Exception('Failed to update like: $e');
    }
  }

  Future<void> toggleCommentLike(
    String postId,
    String commentId,
    String userId,
    bool isLiked,
  ) async {
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);
    try {
      await _firestore.runTransaction((txn) async {
        final snap = await txn.get(commentRef);
        if (!snap.exists) throw Exception('Comment not found');
        final current = (snap.data()?['likeCount'] as int?) ?? 0;
        // `isLiked` represents the new state (true == user now likes the comment).
        final delta = isLiked ? 1 : -1;
        final newCount = (current + delta) < 0
            ? 0
            : (current + delta); // Never allow negative counts.

        txn.update(commentRef, {
          'likeCount': newCount,
          'likes': isLiked
              ? FieldValue.arrayUnion([userId])
              : FieldValue.arrayRemove([userId]),
        });
      });
    } catch (e) {
      throw Exception('Failed to toggle comment like: $e');
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
