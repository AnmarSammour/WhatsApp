import 'package:flutter/material.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_info/add_members.dart';
import 'package:whatsapp/view/group_info/custom_pop_up_menu.dart';

class GroupHeader extends StatelessWidget {
  final GroupChatModel groupChatModel;
  final Future<int> Function(String) getGroupMemberCount;
  final UserModel currentUser;

  const GroupHeader({
    Key? key,
    required this.groupChatModel,
    required this.getGroupMemberCount,
    required this.currentUser,
  }) : super(key: key);

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF02B099)),
            SizedBox(height: 8.0),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 330.0,
      elevation: 0,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var top = constraints.biggest.height;
          var isCollapsed =
              top <= kToolbarHeight + MediaQuery.of(context).padding.top;
          return FlexibleSpaceBar(
            title: isCollapsed
                ? Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: groupChatModel.groupPic.isNotEmpty
                            ? NetworkImage(groupChatModel.groupPic)
                            : null,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        child: groupChatModel.groupPic.isEmpty
                            ? Icon(Icons.group, size: 20, color: Colors.white)
                            : null,
                        radius: 15,
                      ),
                      SizedBox(width: 10),
                      Text(
                        groupChatModel.name,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  )
                : null,
            background: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  backgroundImage: groupChatModel.groupPic.isNotEmpty
                      ? NetworkImage(groupChatModel.groupPic)
                      : null,
                  child: groupChatModel.groupPic.isEmpty
                      ? Icon(Icons.group, size: 50, color: Colors.white)
                      : null,
                ),
                SizedBox(height: 10),
                Text(
                  groupChatModel.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<int>(
                  future: getGroupMemberCount(groupChatModel.groupId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error',
                          style: TextStyle(color: Colors.red, fontSize: 14));
                    } else {
                      int memberCount = snapshot.data ?? 0;
                      return Text(
                        "Group: $memberCount members",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.message, 'Message', () {}),
                    _buildActionButton(Icons.call, 'Audio', () {}),
                    _buildActionButton(Icons.videocam, 'Video', () {}),
                    _buildActionButton(Icons.person_add_alt_outlined, 'Add',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMembers(
                                  userInfo: currentUser,
                                  groupId: groupChatModel.groupId,
                                )),
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        CustomPopupMenu(
          userInfo: currentUser,
          groupId: groupChatModel.groupId,
          initialGroupName: groupChatModel.name,
        ),
      ],
    );
  }
}
