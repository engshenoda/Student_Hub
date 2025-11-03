import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userImage;
  final String text;
  final DateTime createdAt;
  final Map<String, dynamic> likes; // ✅ جديد

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.createdAt,
    required this.likes,
  });

  factory CommentModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    DateTime created;
    if (data['createdAt'] is Timestamp) {
      created = (data['createdAt'] as Timestamp).toDate();
    } else {
      created = DateTime.now();
    }

    return CommentModel(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
      text: data['text'] ?? '',
      createdAt: created,
      likes: Map<String, dynamic>.from(data['likes'] ?? {}), // ✅
    );
  }

  Map<String, dynamic> toMap({bool useServerTimestamp = true}) {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'text': text,
      'likes': likes, // ✅
      'createdAt': useServerTimestamp
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt),
    };
  }
}
