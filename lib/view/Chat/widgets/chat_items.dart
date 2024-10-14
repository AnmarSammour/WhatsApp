import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/contact_info/show_user_dialog.dart';

class ChatItems extends StatelessWidget {
  final String time;
  final String recentSendMessage;
  final String name;
  final String imageUrl;
  final String phoneNumber;
  final String status;
  final String uid;

  const ChatItems({
    Key? key,
    required this.time,
    required this.recentSendMessage,
    required this.name,
    required this.imageUrl,
    required this.phoneNumber,
    required this.status,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final user = UserModel(
      id: uid,
      name: name,
      imageUrl: imageUrl,
      phoneNumber: phoneNumber,
      status: status,
      active: false,
      lastSeen: DateTime.now(),
    );

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
                    onTap: () {
                      showUserDialog(context, user);
                    },
                    child: CircleAvatar(
                      radius: 27.5,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty
                          ? Icon(Icons.person, size: 30, color: Colors.white)
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
                      Text(recentSendMessage,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
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
