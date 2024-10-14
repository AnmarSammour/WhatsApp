import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_info/add_members.dart';
import 'package:whatsapp/view/group_info/custom_pop_up_menu.dart';
import 'package:whatsapp/view/group_info/change_group_image.dart';
import 'package:whatsapp/view/group_info/edit_group_image_screen.dart';

class GroupHeader extends StatelessWidget {
  final GroupChatModel groupChatModel;
  final Future<int> Function(String) getGroupMemberCount;
  final UserModel currentUser;

  GroupHeader({
    Key? key,
    required this.groupChatModel,
    required this.getGroupMemberCount,
    required this.currentUser,
  }) : super(key: key);

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditGroupImageScreen(
            imageFile: File(pickedFile.path),
            groupChatModel: groupChatModel,
          ),
        ),
      );
    }
  }

  void _navigateToChangeGroupImage(BuildContext context) {
    if (groupChatModel.groupPic.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeGroupImage(
            groupChatModel: groupChatModel,
          ),
        ),
      );
    } else {
      _pickImage(context); 
    }
  }

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
            const SizedBox(height: 8.0),
            Text(label, style: const TextStyle(color: Colors.black)),
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
                      GestureDetector(
                        onTap: () => _navigateToChangeGroupImage(context),
                        child: CircleAvatar(
                          backgroundImage: groupChatModel.groupPic.isNotEmpty
                              ? NetworkImage(groupChatModel.groupPic)
                              : null,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          radius: 15,
                          child: groupChatModel.groupPic.isEmpty
                              ? const Icon(Icons.group, size: 20, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        groupChatModel.name,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  )
                : null,
            background: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _navigateToChangeGroupImage(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    backgroundImage: groupChatModel.groupPic.isNotEmpty
                        ? NetworkImage(groupChatModel.groupPic)
                        : null,
                    child: groupChatModel.groupPic.isEmpty
                        ? const Icon(Icons.group, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  groupChatModel.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<int>(
                  future: getGroupMemberCount(groupChatModel.groupId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error',
                          style: TextStyle(color: Colors.red, fontSize: 14));
                    } else {
                      int memberCount = snapshot.data ?? 0;
                      return Text(
                        "Group: $memberCount members",
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.message, 'Message', () {
                    }),
                    _buildActionButton(Icons.call, 'Audio', () {
                    }),
                    _buildActionButton(Icons.videocam, 'Video', () {
                    }),
                    _buildActionButton(Icons.person_add_alt_outlined, 'Add',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMembers(
                            userInfo: currentUser,
                            groupId: groupChatModel.groupId,
                          ),
                        ),
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
        icon: const Icon(Icons.arrow_back),
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
