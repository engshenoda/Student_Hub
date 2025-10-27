import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class PostModel {
  final String id;
  final UserModel user;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final List<String> followers; //  جديد
   final List<String> likesIds; 

  PostModel({
    required this.id,
    required this.user,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    this.followers = const [],
    this.likesIds = const []
  });

  factory PostModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      user: UserModel.fromMap(Map<String, dynamic>.from(data['user'] ?? {})),
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      followers: List<String>.from(data['followers'] ?? []),
      likesIds: List<String>.from(data['likesIds'] ?? []),
    );
  }
}
