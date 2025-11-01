import '../../../data/repo/massege_model.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoading;
  final String? errorMessage;

  ChatState({
    required this.messages,
    required this.isLoading,
    this.errorMessage,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  factory ChatState.initial() {
    return ChatState(
      messages: [],
      isLoading: false,
    );
  }
}
