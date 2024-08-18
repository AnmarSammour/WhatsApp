import 'package:flutter/material.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_info/group_info.dart';

void showGroupDialog(
  BuildContext context,
  GroupChatModel groupChatModel,
  UserModel currentUser,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: groupChatModel.groupPic.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(groupChatModel.groupPic),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: groupChatModel.groupPic.isEmpty
                          ? Colors.grey.shade300
                          : Colors.transparent,
                    ),
                    child: groupChatModel.groupPic.isEmpty
                        ? Center(
                            child: Icon(Icons.group,
                                size: 100, color: Colors.white))
                        : null,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.black.withOpacity(0.5),
                      child: Text(
                        groupChatModel.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.message, color: Color(0xFF02B099)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.call, color: Color(0xFF02B099)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Color(0xFF02B099)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF02B099),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupInfoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
