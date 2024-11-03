import 'package:flutter/material.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_info/show_group_dialog.dart';

class ChatGroupItems extends StatelessWidget {
  final String time;
  final String recentSendMessage;
  final String senderName;
  final String name;
  final String imageUrl;
  final String groupId;
  final bool isCurrentUser;
  final bool isGroupCreated;
  final List<UserModel> members;
  final UserModel currentUser;

  const ChatGroupItems({
    Key? key,
    required this.time,
    required this.recentSendMessage,
    required this.senderName,
    required this.name,
    required this.imageUrl,
    required this.groupId,
    required this.members,
    required this.currentUser,
    this.isCurrentUser = false,
    this.isGroupCreated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = GroupChatModel(
      name: name,
      groupCreatorId: '',
      groupCreator: '',
      timeSent: DateTime.now(),
      senderId: '',
      senderName: '',
      groupId: groupId,
      lastMessage: '',
      senderImage: '',
      groupPic: imageUrl,
      membersUid: [],
    );

    String displayMessage;
    if (isGroupCreated && recentSendMessage.isEmpty) {
      displayMessage =
          isCurrentUser ? 'You created this group' : '$senderName added you';
    } else {
      displayMessage = recentSendMessage;
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showGroupDialog(context, group, currentUser);
                    },
                    child: CircleAvatar(
                      radius: 27.5,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.group,
                              size: 30, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (!isGroupCreated &&
                              recentSendMessage != 'You created this group' &&
                              recentSendMessage != '$senderName added you')
                            Text(
                              isCurrentUser ? "You: " : "$senderName: ",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            displayMessage,
                            style: const TextStyle(
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
