import 'package:equatable/equatable.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:whatsapp/model/group_chat.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatModel> chatModel;
  final List<GroupChatModel> groupChats;

  const ChatLoaded({
    required this.chatModel,
    required this.groupChats,
  });

  @override
  List<Object> get props => [chatModel, groupChats];
}

class ChatFailure extends ChatState {}
