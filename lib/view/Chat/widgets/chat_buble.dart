import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/enum/message_enum.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/view/Chat/widgets/chat_bubble_painter.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxMessageWidth = screenWidth * 0.75;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxMessageWidth),
              child: CustomPaint(
                painter: ChatBubblePainter(isFromFriend: false),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (message.messageType == MessageType.image)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.network(
                              message.message.split('\n').first,
                              fit: BoxFit.cover,
                            ),
                            if (message.message.split('\n').length > 1)
                              Text(
                                message.message
                                    .split('\n')
                                    .sublist(1)
                                    .join('\n'),
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.right,
                              ),
                          ],
                        )
                      else
                        Text(
                          message.message,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.right,
                        ),
                      SizedBox(height: 5),
                      Text(
                        DateFormat('hh:mm a').format(message.time.toDate()),
                        style:
                            TextStyle(color: Color(0xff606D75), fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
