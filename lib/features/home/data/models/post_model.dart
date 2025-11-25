// features/home/data/models/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MediaItem {
  final String url;
  final String type;
  MediaItem({required this.url, required this.type});

  factory MediaItem.fromJson(Map<String, dynamic> json) =>
      MediaItem(url: json['url'] as String, type: json['type'] as String);

  Map<String, dynamic> toJson() => {'url': url, 'type': type};
}

class LinkPreview {
  final String? title;
  final String? description;
  final String? image;
  final String url;

  LinkPreview({
    this.title,
    this.description,
    this.image,
    required this.url,
  });

  factory LinkPreview.fromJson(Map<String, dynamic> json) => LinkPreview(
        title: json['title'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        url: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (image != null) 'image': image,
        'url': url,
      };
}

class PostModel {
  final String id;
  final String authorId;
  final String? authorName;
  final String? authorImage;
  final String content;
  final List<MediaItem> media;
  final List<String> links;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likeCount;
  final int commentCount;
  final int repostCount;
  final bool isRepost;
  final String? originalPostId;
  final LinkPreview? linkPreview;
  final List<String> likes;

  PostModel({
    this.authorName,
    this.authorImage,
    required this.id,
    required this.authorId,
    required this.content,
    this.media = const [],
    this.links = const [],
    required this.createdAt,
    this.updatedAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.repostCount = 0,
    this.isRepost = false,
    this.originalPostId,
    this.linkPreview,
    this.likes = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return PostModel(
      id: id ?? (json['id'] as String? ?? ''),
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String?,
      authorImage: json['authorImage'] as String?,
      content: json['content'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      links: List<String>.from(json['links'] ?? []),
      createdAt: (json['createdAt'] is Timestamp)
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] is Timestamp)
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt'] as String),
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      repostCount: json['repostCount'] as int? ?? 0,
      isRepost: json['isRepost'] as bool? ?? false,
      originalPostId: json['originalPostId'] as String?,
      linkPreview: json['linkPreview'] != null
          ? LinkPreview.fromJson(json['linkPreview'] as Map<String, dynamic>)
          : null,
      likes: List<String>.from(json['likes'] ?? []),
    );
  }

  factory PostModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel.fromJson(data, id: doc.id);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorId': authorId,
        'authorName': authorName,
        'authorImage': authorImage,
        'content': content,
        'media': media.map((m) => m.toJson()).toList(),
        'links': links,
        'createdAt': Timestamp.fromDate(createdAt),
        if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
        'likeCount': likeCount,
        'commentCount': commentCount,
        'repostCount': repostCount,
        'isRepost': isRepost,
        if (originalPostId != null) 'originalPostId': originalPostId,
        if (linkPreview != null) 'linkPreview': linkPreview!.toJson(),
        'likes': likes,
      };

  PostModel copyWith({
    
    String? id,
    String? content,
    List<MediaItem>? media,
    List<String>? links,
    DateTime? updatedAt,
    int? likeCount,
    int? commentCount,
    int? repostCount,
    LinkPreview? linkPreview,
    List<String>? likes,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId,
      authorName: authorName,
      authorImage: authorImage,
      content: content ?? this.content,
      media: media ?? this.media,
      links: links ?? this.links,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      repostCount: repostCount ?? this.repostCount,
      isRepost: isRepost,
      originalPostId: originalPostId,
      linkPreview: linkPreview ?? this.linkPreview,
      likes: likes ?? this.likes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}