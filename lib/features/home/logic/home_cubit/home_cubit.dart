import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import '../../data/models/post_model.dart';
import 'home_state.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/user_model.dart';
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()){
    getCurrentUser();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;
      final ImagePicker _picker = ImagePicker();

       File? postImage;


  User? currentUser;
  List<PostModel> posts = [];

  Map<String, List<CommentModel>> comments = {}; // 👈 كل بوست وليه comments

  // تحميل البوستات
  Future<void> loadPosts() async {
    emit(HomeLoading());
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      posts = snapshot.docs.map((doc) => PostModel.fromDoc(doc)).toList();
      emit(HomeLoaded(posts));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  //  دالة الـ Like / Unlike
  Future<void> toggleLike(String postId) async {
    try {
      final index = posts.indexWhere((post) => post.id == postId);
      if (index == -1) return;

      final post = posts[index];
      final newLikesCount = post.likesCount + 1;

      // تحديث فى Firestore
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'likesCount': newLikesCount});

      // تحديث محلى للـ UI
      posts[index] = PostModel(
        id: post.id,
        user: post.user,
        content: post.content,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likesCount: newLikesCount,
        commentsCount: post.commentsCount,
      );

      emit(HomeLoaded(List.from(posts)));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
Future<void> toggleFollow(String postId) async {
  final currentUserId = currentUser?.uid;
if (currentUserId == null) return; 

  try {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = posts[index];
    final followers = List<String>.from(post.followers);

    bool isFollowing = followers.contains(currentUserId);

    if (isFollowing) {
      followers.remove(currentUserId);
    } else {
      followers.add(currentUserId);
    }

    // تحديث Firestore
    await _firestore.collection('posts').doc(postId).update({
      'followers': followers,
    });

    // تحديث محلى
    posts[index] = PostModel(
      id: post.id,
      user: post.user,
      content: post.content,
      imageUrl: post.imageUrl,
      createdAt: post.createdAt,
      likesCount: post.likesCount,
      commentsCount: post.commentsCount,
      followers: followers,
    );

    emit(HomeLoaded(List.from(posts)));
  } catch (e) {
    emit(HomeError(e.toString()));
  }
}

  // جلب التعليقات الخاصة ببوست معين
  Future<void> fetchComments(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      final commentsList = snapshot.docs
          .map((doc) => CommentModel.fromDoc(doc))
          .toList();

      comments[postId] = commentsList;
      emit(HomeCommentsLoaded(postId, commentsList));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }


// إضافة كومنت جديد
    Future<void> addComment(String postId, String text) async {
    final currentUserId = currentUser?.uid;
if (currentUserId == null) return; 
final currentUserName = currentUser?.displayName ?? 'Unknown User';
final currentUserImage = currentUser?.photoURL ?? 'https://i.pravatar.cc/150?img=1';

    try {
      final newComment = CommentModel(
        id: '',
        postId: postId,
        userId: currentUserId,
        userName: currentUserName,
        userImage: currentUserImage,
        text: text,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(newComment.toMap());

      await fetchComments(postId); // إعادة تحميل الكومنتات بعد الإضافة
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }


//ده علشان يجيب بيانات المستخدم الى داخل حاليا 

   void getCurrentUser() {
    currentUser = _auth.currentUser;
  }


   ///  pick image from gallery
  Future<void> pickPostImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePicked());
    }
  }



    ///  upload post (text + optional image)
  Future<void> createPost({
  required UserModel user,
  required String content,
  }) async {
    try {
      emit(CreatePostLoading());

      String? imageUrl;
      if (postImage != null) {
        // Upload image to Firebase Storage
        final ref = _storage.ref().child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(postImage!);
        imageUrl = await ref.getDownloadURL();
      }

      // Add post to Firestore
      await _firestore.collection('posts').add({
        'user': user.toMap(),
        'content': content,
        'imageUrl': imageUrl,
        'likesIds': [],
        'createdAt': FieldValue.serverTimestamp(),
        'likesCount': 0,
        'commentsCount': 0,
      });

      postImage = null;
      emit(CreatePostSuccess());
    } catch (e) {
      emit(CreatePostError(e.toString()));
    }
  }

  ///  عمل Repost لبوست موجود
Future<void> repost({
    required String originalPostId,
  required UserModel currentUser,
}) async {
  try {
    // جيب بيانات البوست الأصلى
    final originalDoc =
        await _firestore.collection('posts').doc(originalPostId).get();

    if (!originalDoc.exists) {
      emit(HomeError('The original post is not available'));
      return;
    }

    final originalData = originalDoc.data() as Map<String, dynamic>;

    //  أنشئ بوست جديد بنفس المحتوى
    await _firestore.collection('posts').add({


      'user': currentUser.toMap(),
      'content': originalData['content'],
      'imageUrl': originalData['imageUrl'],
      'isRepost': true,
      'originalUserName': (originalData['user'] ?? {})['name'],
      'originalPostId': originalPostId,
      'createdAt': FieldValue.serverTimestamp(),
      'likesIds': [],
      'followers': [],
      'likesCount': 0,
      'commentsCount': 0,
    });

    emit(RepostSuccess());
  } catch (e) {
    emit(HomeError('An error occurred while re-posting: $e'));
  }

}}

  



