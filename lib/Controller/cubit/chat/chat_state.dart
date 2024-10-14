part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatLoaded extends ChatState {
  final List<ChatModel> chatModel;

  ChatLoaded({required this.chatModel});

  @override
  List<Object> get props => [chatModel];
}

class ChatError extends ChatState {
  final String message;

  ChatError({required this.message});

  @override
  List<Object> get props => [message];
}
