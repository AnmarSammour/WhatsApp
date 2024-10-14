import 'package:flutter/material.dart';
import 'package:whatsapp/view/group_chat/widgets/chat_body_group.dart';

class ChatGroupView extends StatelessWidget {
  final String groupId;
  final String groupName;
  final List<String> memberIds;
  final String groupImageUrl;

  const ChatGroupView({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.memberIds,
    required this.groupImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBodyGroup(
        groupId: groupId,
        memberIds: memberIds,
        groupName: groupName,
        groupImageUrl: groupImageUrl,
      ),
    );
  }
}
