import 'package:flutter/material.dart';
import 'package:whatsapp/view/Chat/widgets/chat_body.dart';

class ChatViewPage extends StatelessWidget {
  final String senderUID;
  final String recipientUID;
  final String senderName;
  final String recipientName;
  final String recipientPhoneNumber;
  final String senderPhoneNumber;
  final String imageUrl;

  const ChatViewPage({
    Key? key,
    required this.senderUID,
    required this.recipientUID,
    required this.senderName,
    required this.recipientName,
    required this.recipientPhoneNumber,
    required this.senderPhoneNumber,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBody(
        senderUID: senderUID,
        recipientUID: recipientUID,
        senderName: senderName,
        recipientName: recipientName,
        recipientPhoneNumber: recipientPhoneNumber,
        senderPhoneNumber: senderPhoneNumber,
        imageUrl: imageUrl,
      ),
    );
  }
}
