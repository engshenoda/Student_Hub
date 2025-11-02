import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chatId = _generateChatId(senderId, receiverId);

    final chatRef = _firestore.collection('chats').doc(chatId);
final messagesRef = _firestore.collection('chats').doc(chatId).collection('messages');
    final timestamp = FieldValue.serverTimestamp();

    await messagesRef.add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'isSeen': false,    
    });

    await chatRef.set({
      'chatId': chatId,
      'participants': [senderId, receiverId],
      'lastMessage': message,
      'lastSenderId': senderId,
      'lastReceiverId': receiverId,
      'lastTimestamp': timestamp,
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
    final chatId = _generateChatId(senderId, receiverId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markMessagesAsSeen(String currentUserId, String otherUserId) async {
    final chatId = _generateChatId(currentUserId, otherUserId);
    final messagesRef = _firestore.collection('chats').doc(chatId).collection('messages');

    final unreadMessages = await messagesRef
        .where('receiverId', isEqualTo: currentUserId)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isSeen': true});
    }
  }

  // حذف الشات 
 Future<void> deleteChat(String senderId, String receiverId) async {
  try {
    final chatId = _generateChatId(senderId, receiverId);

    final chatRef = _firestore.collection('chats').doc(chatId);

    final messages = await chatRef.collection('messages').get();
    for (var msg in messages.docs) {
      await msg.reference.delete();
    }

    await chatRef.delete();
  } catch (e) {
    print("Error deleting chat: $e");
  }
}


  String _generateChatId(String uid1, String uid2) {
    final uids = [uid1, uid2];
    uids.sort(); 
    return '${uids[0]}_${uids[1]}';
  }
}
