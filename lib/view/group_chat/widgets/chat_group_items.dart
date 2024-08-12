import 'package:flutter/material.dart';

class ChatGroupItems extends StatelessWidget {
  final String time;
  final String recentSendMessage;
  final String senderName;
  final String name;
  final String imageUrl;
  final String groupId;
  final bool isCurrentUser;
  final bool isGroupCreated;

  const ChatGroupItems({
    Key? key,
    required this.time,
    required this.recentSendMessage,
    required this.senderName,
    required this.name,
    required this.imageUrl,
    required this.groupId,
    this.isCurrentUser = false,
    this.isGroupCreated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayMessage;
    if (isGroupCreated && recentSendMessage.isEmpty) {
      displayMessage =
          isCurrentUser ? 'You created this group' : '$senderName added you';
    } else {
      displayMessage = recentSendMessage;
    }

    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 27.5,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty
                          ? Icon(Icons.group, size: 30, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          if (!isGroupCreated &&
                              recentSendMessage != 'You created this group' &&
                              recentSendMessage != '$senderName added you')
                            Text(
                              isCurrentUser ? "You: " : "$senderName: ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            displayMessage,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text(time),
            ],
          ),
        ],
      ),
    );
  }
}
