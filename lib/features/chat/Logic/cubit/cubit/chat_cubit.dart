import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_state.dart';
import '../../../data/repo/chat_response.dart';
import '../../../data/repo/massege_model.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;

  ChatCubit(this._repository) : super(ChatState.initial());

  void loadMessages(String senderId, String receiverId) {
    emit(state.copyWith(isLoading: true));

    _repository.getMessages(senderId, receiverId).listen((messages) {
      emit(state.copyWith(messages: messages, isLoading: false));
    }, onError: (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    });
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final newMessage = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
    );

    try {
      await _repository.sendMessage(newMessage);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

