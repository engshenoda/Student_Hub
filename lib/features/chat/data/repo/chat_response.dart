import 'package:cloud_firestore/cloud_firestore.dart';
import 'massege_model.dart';
class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    final chatId = _getChatId(message.senderId, message.receiverId);

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    final chatId = _getChatId(senderId, receiverId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}

