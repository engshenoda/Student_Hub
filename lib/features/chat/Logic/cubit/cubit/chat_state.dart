
part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatModel> chats;
  ChatLoaded(this.chats);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}


/// Messages states
class MessageLoading extends ChatState {
  final String chatId;
  MessageLoading(this.chatId);
}

class MessagesLoaded extends ChatState {
  final String chatId;
  final List<MessageModel> messages;
  MessagesLoaded(this.chatId, this.messages);
}
