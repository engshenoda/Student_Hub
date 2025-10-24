// lib/features/chat/logic/chat_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:linkedin/features/chat/data/chatmodel.dart';
import 'package:linkedin/features/chat/repo/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  // optional local subscriptions if you want the cubit to manage them
  StreamSubscription<List<ChatModel>>? _chatsSub;
  StreamSubscription<List<MessageModel>>? _messagesSub;

  ChatCubit({required this.repository}) : super(ChatInitial());

  /// Start listening to chats of a user and emit ChatLoaded updates
  void listenToChats(String userId) {
    emit(ChatLoading());
    _chatsSub?.cancel();
    _chatsSub = repository.subscribeToChats(userId).listen((chats) {
      emit(ChatLoaded(chats));
    }, onError: (e) {
      emit(ChatError(e.toString()));
    });
  }

  /// Subscribe to messages for a particular chat. Emits MessagesUpdated states
  void listenToMessages(String chatId) {
    emit(MessageLoading(chatId));
    _messagesSub?.cancel();
    _messagesSub = repository.subscribeToMessages(chatId).listen((messages) {
      emit(MessagesLoaded(chatId, messages));
    }, onError: (e) {
      emit(ChatError(e.toString()));
    });
  }

  Future<void> sendText({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    await repository.sendMessage(chatId: chatId, senderId: senderId, text: text);
  }

  Future<String> createChat({
    required List<String> participants,
    String? title,
    String? avatarUrl,
  }) async {
    return repository.createChat(participants: participants, title: title, avatarUrl: avatarUrl);
  }

  Future<void> markSeen(String chatId, String messageId, String userId) async {
    await repository.markMessageSeen(chatId, messageId, userId);
  }

  @override
  Future<void> close() {
    _chatsSub?.cancel();
    _messagesSub?.cancel();
    return super.close();
  }
}
