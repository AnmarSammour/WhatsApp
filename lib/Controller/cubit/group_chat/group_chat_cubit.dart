import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'group_chat_state.dart';

class GroupChatCubit extends Cubit<GroupChatState> {
  GroupChatCubit() : super(GroupChatInitial());
}
