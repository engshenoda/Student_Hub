// lib/features/chat/data/models.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// User model
class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    }..removeWhere((_, v) => v == null);
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};
    return UserModel.fromMap(data, snap.id);
  }
}

/// Chat model (supports 1:1 and group)
class ChatModel {
  final String id;
  final String title; // optional
  final List<String> participants; // user ids
  final String? lastMessage;
  final Timestamp? lastUpdated;
  final String? avatarUrl;

  ChatModel({
    required this.id,
    required this.participants,
    this.title = '',
    this.lastMessage,
    this.lastUpdated,
    this.avatarUrl,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      title: map['title'] ?? '',
      lastMessage: map['lastMessage'],
      lastUpdated: map['lastUpdated'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'title': title,
      'lastMessage': lastMessage,
      'lastUpdated': lastUpdated,
      'avatarUrl': avatarUrl,
    }..removeWhere((_, v) => v == null);
  }

  factory ChatModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};
    return ChatModel.fromMap(data, snap.id);
  }
}

/// Message model
class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String? text;
  final String? imageUrl;
  final Timestamp timestamp;
  final Map<String, bool>? seenBy;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.timestamp,
    this.seenBy,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'],
      imageUrl: map['imageUrl'],
      timestamp: map['timestamp'] ?? Timestamp.now(),
      seenBy: map['seenBy'] != null
          ? Map<String, bool>.from(map['seenBy'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'seenBy': seenBy,
    }..removeWhere((_, v) => v == null);
  }

  factory MessageModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};
    return MessageModel.fromMap(data, snap.id);
  }
}
