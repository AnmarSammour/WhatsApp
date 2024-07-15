part of 'group_chat_cubit.dart';

abstract class GroupChatState extends Equatable {
  const GroupChatState();

  @override
  List<Object> get props => [];
}

class GroupChatInitial extends GroupChatState {}

class GroupChatLoading extends GroupChatState {}

class GroupChatCreated extends GroupChatState {}

class GroupChatImageSelected extends GroupChatState {
  final File image;

  GroupChatImageSelected({required this.image});

  @override
  List<Object> get props => [image];
}

class GroupChatLoaded extends GroupChatState {
  final List<MessageModel> messages;

  GroupChatLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

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
