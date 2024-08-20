import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_info/group_actions.dart';
import 'package:whatsapp/view/group_info/group_header.dart';
import 'package:whatsapp/view/group_info/group_info_members.dart';
import 'package:whatsapp/view/group_info/group_settings_section.dart';

class GroupInfoPage extends StatelessWidget {
  final GroupChatModel groupChatModel;
  final UserModel currentUser;

  const GroupInfoPage({
    Key? key,
    required this.groupChatModel,
    required this.currentUser,
  }) : super(key: key);

  Stream<DocumentSnapshot> _getGroupStream(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getGroupStream(groupChatModel.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Group not found.'));
          }

          var groupData = snapshot.data!.data() as Map<String, dynamic>;
          var updatedGroupChatModel = GroupChatModel.fromMap(groupData);

          return CustomScrollView(
            slivers: [
              GroupHeader(
                  groupChatModel: updatedGroupChatModel,
                  getGroupMemberCount: (id) async =>
                      updatedGroupChatModel.membersUid.length,
                  currentUser: currentUser),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 5,
                      ),
                    ),
                    GroupSettingsSection(user: currentUser),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 5,
                      ),
                    ),
                    GroupMembersList(
                      groupId: updatedGroupChatModel.groupId,
                      currentUser: currentUser,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 5,
                      ),
                    ),
                    ActionButtons()
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
