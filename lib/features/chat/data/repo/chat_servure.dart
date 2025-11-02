import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chatId = _getChatId(senderId, receiverId);

    final messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message.trim(),
      'timestamp': FieldValue.serverTimestamp(), 
      'isRead': false,
    };

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    await _firestore.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'lastMessage': message.trim(),
      'lastSenderId': senderId,
      'lastReceiverId': receiverId,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'participants': [senderId, receiverId],
    }, SetOptions(merge: true));
  }

 Stream<QuerySnapshot> getMessages(String userId, String receiverId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(_getChatId(userId, receiverId))
      .collection('messages')
      .orderBy('timestamp', descending: true) 
      .snapshots();
}

  String _getChatId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
