part of 'group_chat_cubit.dart';

abstract class GroupChatState extends Equatable {
  const GroupChatState();

  @override
  List<Object> get props => [];
}

class GroupChatInitial extends GroupChatState {}

class GroupChatLoaded extends GroupChatState {
  final List<MessageModel> messages;

  GroupChatLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class GroupChatFailure extends GroupChatState {}

class GroupChatLoading extends GroupChatState {}

class GroupChatError extends GroupChatState {
  final String errorMessage;

  GroupChatError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GroupChatUsersLoaded extends GroupChatState {
  final List<UserModel> users;

  const GroupChatUsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class GroupChatImageSelected extends GroupChatState {
  final File image;

  GroupChatImageSelected({required this.image});

  @override
  List<Object> get props => [image];
}

class GroupChatUpdated extends GroupChatState {
  final GroupChatModel updatedGroupChat;

  const GroupChatUpdated(this.updatedGroupChat);

  @override
  List<Object> get props => [updatedGroupChat];
}
