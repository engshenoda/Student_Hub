import 'package:cloud_firestore/cloud_firestore.dart';
late final Post? originalPost; // البوست اللي بيتم عمل Repost له
late final bool isRepost; // هل البوست ده Repost
class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String text;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, bool> likes;
  final int commentsCount;
  

  var originalPost;
  
  var isRepost;
  

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.text,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
      this.originalPost,
  this.isRepost = false,
    Map<String, bool>? likes,
    this.commentsCount = 0,
  }) : likes = likes ?? {};

  factory Post.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'],
      text: data['text'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
      likes: Map<String, bool>.from(data['likes'] ?? {}),
      commentsCount: (data['commentsCount'] ?? 0) as int,
        isRepost: data['isRepost'] ?? false,
    originalPost: data['originalPost'] != null
        ? Post.fromMap(Map<String, dynamic>.from(data['originalPost']))
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'text': text,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'likes': likes,
      'commentsCount': commentsCount,
        'isRepost': isRepost,
    'originalPost': originalPost?.toMap(),
    }..removeWhere((k, v) => v == null);
  }
   factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      id: data['id'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'],
      text: data['text'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] is Timestamp
              ? (data['updatedAt'] as Timestamp).toDate()
              : DateTime.tryParse(data['updatedAt'].toString()))
          : null,
      likes: Map<String, bool>.from(data['likes'] ?? {}),
      commentsCount: (data['commentsCount'] ?? 0) as int,
      isRepost: data['isRepost'] ?? false,
      originalPost: data['originalPost'] != null
          ? Post.fromMap(Map<String, dynamic>.from(data['originalPost']))
          : null,
    );
  }

  Post copyWith({
    String? text,
    String? imageUrl,
    DateTime? updatedAt,
    Map<String, bool>? likes,
    int? commentsCount,
  }) {
    return Post(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorAvatar: authorAvatar,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
