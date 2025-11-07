import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';

class PostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🟢 Add new post
  Future<void> addPost(PostModel post) async {
    try {
      final docRef = post.id.isEmpty
          ? _firestore.collection('posts').doc()
          : _firestore.collection('posts').doc(post.id);

      final postWithId = post.id.isEmpty ? post.copyWith(id: docRef.id) : post;
      await docRef.set(postWithId.toJson());
    } catch (e) {
      throw Exception('❌ Failed to add post: $e');
    }
  }

  /// 🟡 Update an existing post
  Future<void> updatePost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).update(post.toJson());
    } catch (e) {
      throw Exception('❌ Failed to update post: $e');
    }
  }

  /// 🔴 Delete a post by ID
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw Exception('❌ Failed to delete post: $e');
    }
  }

  /// 👀 Stream all posts (ordered by date)
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

  /// 💬 Add comment to a post (subcollection)
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

  /// 🟡 Update a comment
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

  /// 👀 Stream comments for a specific post
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

  /// ❤️ Toggle Like (increment/decrement likeCount only)
  Future<void> toggleLike(String postId, bool isLiked) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likeCount': FieldValue.increment(isLiked ? -1 : 1),
      });
    } catch (e) {
      throw Exception('Failed to update like count: $e');
    }
  }

  // 👇 ✅ الوظيفة الجديدة: جلب بيانات المستخدم من Firestore
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
