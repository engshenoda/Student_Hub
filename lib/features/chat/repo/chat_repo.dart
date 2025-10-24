// lib/features/chat/data/chat_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/chat/data/chatmodel.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  ChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _chats => _firestore.collection('chats');

  // ---- Users ----
  Future<void> createOrUpdateUser(UserModel user) async {
    await _users.doc(user.id).set(user.toMap(), SetOptions(merge: true));
  }

  Stream<UserModel> userStream(String userId) {
    return _users.doc(userId).snapshots().map((s) => UserModel.fromSnapshot(s));
  }

  Future<List<UserModel>> listAllUsers({int limit = 50}) async {
    final snap = await _users.limit(limit).get();
    return snap.docs.map((d) => UserModel.fromSnapshot(d)).toList();
  }

  // ---- Chats ----
  Stream<List<ChatModel>> subscribeToChats(String userId) {
    return _chats
        .where('participants', arrayContains: userId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => ChatModel.fromSnapshot(d)).toList());
  }

  Future<String> createChat({
    required List<String> participants,
    String? title,
    String? avatarUrl,
  }) async {
    final doc = _chats.doc();
    final chat = ChatModel(
      id: doc.id,
      participants: participants,
      title: title ?? '',
      avatarUrl: avatarUrl,
      lastUpdated: Timestamp.now(),
    );
    await doc.set({
      ...chat.toMap(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> addParticipant(String chatId, String userId) async {
    await _chats.doc(chatId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> updateChatLastMessage(String chatId, String lastMessage) async {
    await _chats.doc(chatId).update({
      'lastMessage': lastMessage,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // ---- Messages ----
  Stream<List<MessageModel>> subscribeToMessages(String chatId, {int limit = 200}) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => MessageModel.fromSnapshot(d)).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    String? text,
    String? imageUrl,
  }) async {
    final messagesRef = _chats.doc(chatId).collection('messages').doc();
    final map = <String, dynamic>{
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    }..removeWhere((_, v) => v == null);
    await messagesRef.set(map);

    // update chat overview
    await updateChatLastMessage(chatId, text ?? (imageUrl != null ? '[image]' : ''));
  }

  Future<void> markMessageSeen(String chatId, String messageId, String userId) async {
    final msgRef = _chats.doc(chatId).collection('messages').doc(messageId);
    await msgRef.set({'seenBy': {userId: true}}, SetOptions(merge: true));
  }
}
