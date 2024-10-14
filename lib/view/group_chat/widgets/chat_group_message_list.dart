import 'package:flutter/material.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/view/Chat/widgets/chat_buble.dart';
import 'package:whatsapp/view/group_chat/widgets/chat_buble_friend_group.dart';

class ChatGroupMessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final String senderId;
  final String imageUrl;
  final String senderName;

  const ChatGroupMessageList({
    Key? key,
    required this.messages,
    required this.senderId,
    required this.imageUrl,
    required this.senderName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (_, index) {
        final reversedIndex = messages.length - 1 - index;
        final message = messages[reversedIndex];

        if (message.senderUID == senderId) {
          return ChatBubble(message: message);
        } else {
          return ChatBubbleForFriendGroup(
            message: message,
            senderName: message.senderName,
            senderImage: message.senderImage,
          );
        }
      },
    );
  }
}
