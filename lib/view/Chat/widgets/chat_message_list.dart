import 'package:flutter/material.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/view/Chat/widgets/chat_buble.dart';
import 'package:whatsapp/view/Chat/widgets/chat_buble_friend.dart';

class ChatMessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final String senderUID;
  final String imageUrl;

  const ChatMessageList({
    Key? key,
    required this.messages,
    required this.senderUID,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (_, index) {
              final reversedIndex = messages.length - 1 - index;

              final message = messages[reversedIndex];

              if (message.senderUID == senderUID) {
                return ChatBubble(message: message);
              } else {
                return ChatBubbleForFriend(message: message);
              }
            },
          ),
        ),
      ],
    );
  }
}
