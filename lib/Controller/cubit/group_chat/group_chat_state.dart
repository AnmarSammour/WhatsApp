part of 'group_chat_cubit.dart';

sealed class GroupChatState extends Equatable {
  const GroupChatState();

  @override
  List<Object> get props => [];
}

final class GroupChatInitial extends GroupChatState {}
