import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:linkedin/core/constant/constant_collections.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';


class PostService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  PostService({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  CollectionReference get _postsCol => _firestore.collection(ConstantCollections.posts);

 Future<Map<String, dynamic>?> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection(ConstantCollections.users)
        .doc(currentUser.uid)
        .get();

    return doc.data();
  }



  Stream<List<Post>> postsStream() {
    return _postsCol.orderBy('createdAt', descending: true).snapshots().map((snap) {
      return snap.docs.map((d) => Post.fromDoc(d)).toList();
    });
  }

Future<void> addPost({required Post post, File? imageFile}) async {
  String? imageUrl;

  // ✅ لو فيه صورة، ارفعها على Firebase Storage
   if (imageFile != null) {
    imageUrl = imageFile.path; // ده المسار المحلي
  }

  // ✅ أضف البوست إلى Firestore
  final docRef = await _postsCol.add({
    ...post.toMap(),

    'imageUrl': imageUrl,
    'createdAt': DateTime.now(),

  });

  // ✅ حدّث الـ document علشان تضيف الـ id الحقيقي جوه البيانات
  await docRef.update({'id': docRef.id});
}





  Future<void> toggleCommentLike(String postId, String commentId, String userId) async {
    final commentRef = _postsCol.doc(postId).collection('comments').doc(commentId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(commentRef);
      if (!snap.exists) return;
      final data = snap.data() ?? {};
      final likes = Map<String, dynamic>.from(data['likes'] ?? {});
      if (likes.containsKey(userId)) {
        likes.remove(userId);
      } else {
        likes[userId] = true;
      }
      tx.update(commentRef, {'likes': likes});
    });
  }










  Future<void> editPost({
  required String postId,
  required Map<String, dynamic> updateData,
  File? newImage,
}) async {
  if (newImage != null) {
    // نخزن المسار المحلي بدل ما نرفعها
    updateData['imageUrl'] = newImage.path;
  }

  updateData['updatedAt'] = Timestamp.now();
  await _postsCol.doc(postId).update(updateData);
}


  Future<void> deletePost(String postId) async {
    // optional: delete storage file if you stored file path
    await _postsCol.doc(postId).delete();
  }

 Future<void> toggleLike(String postId, String userId) async {
  final docRef = _postsCol.doc(postId);

  await _firestore.runTransaction((tx) async {
    final snapshot = await tx.get(docRef);
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    final likes = Map<String, dynamic>.from(data['likes'] ?? {});
    int likesCount = (data['likesCount'] ?? likes.length) as int;

    if (likes.containsKey(userId)) {
      // المستخدم بالفعل عامل لايك → نشيله
      likes.remove(userId);
      likesCount = (likesCount > 0) ? likesCount - 1 : 0;
    } else {
      // المستخدم بيدوس لايك جديد
      likes[userId] = true;
      likesCount++;
    }

    // تحديث البيانات في Firestore
    tx.update(docRef, {
      'likes': likes,
      'likesCount': likesCount,
    });
  });
}















  // Comment handling can be in subcollection 'posts/{id}/comments'
  Future<void> addComment(String postId, String userId, String userName, String text) async {
    final commentsRef = _postsCol.doc(postId).collection('comments');
    final newComment = {
      'userId': userId,
      'userName': userName,
      'text': text,
      'createdAt': Timestamp.now(),
    };
    final batch = _firestore.batch();
    final newDoc = commentsRef.doc();
    batch.set(newDoc, newComment);
    final postRef = _postsCol.doc(postId);
    batch.update(postRef, {'commentsCount': FieldValue.increment(1)});
    await batch.commit();
  }
    Stream<List<CommentModel>> getComments(String postId) {
    return _postsCol
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CommentModel.fromDoc(d)).toList());
  }
  Future<void> repostPost({
  required Post originalPost,
  required String userId,
  required String userName,
  String? userAvatar,
  String? caption,
}) async {
 final newPost = Post(
  id: '',
  authorId: userId,
  authorName: userName,
  authorAvatar: userAvatar,
  text: caption ?? '',
  imageUrl: originalPost.imageUrl, // ✅ كده الصورة هتتنقل
  createdAt: DateTime.now(),
  isRepost: true,
  originalPost: originalPost,
);

  await _postsCol.add(newPost.toMap());
}


}
