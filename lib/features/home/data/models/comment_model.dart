import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likeCount;
  final String? parentCommentId; // for reply

CommentModel({
  required this.id,
  required this.postId,
  required this.authorId,
  required this.content,
  required this.createdAt,
  this.updatedAt,
  this.likeCount = 0,
  this.parentCommentId,
});

  

  factory CommentModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return CommentModel(
      id: id ?? (json['id'] as String? ?? ''),
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      createdAt: (json['createdAt'] is Timestamp)
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] is Timestamp)
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt'] as String),
      likeCount: json['likeCount'] as int? ?? 0,
      parentCommentId: json['parentCommentId'] as String?,
    );
  }

  factory CommentModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel.fromJson(data, id: doc.id);
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'authorId': authorId,
        'content': content,
        'createdAt': Timestamp.fromDate(createdAt),
        if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
        'likeCount': likeCount,
        if (parentCommentId != null) 'parentCommentId': parentCommentId,
      };

  CommentModel copyWith({
    String? id,
    String? content,
    DateTime? updatedAt,
    int? likeCount,
  }) {
    return CommentModel(
      id: id?? this.id,
      postId: postId,
      authorId: authorId,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      parentCommentId: parentCommentId,
    );
  }
}