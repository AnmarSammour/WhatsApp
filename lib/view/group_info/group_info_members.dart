import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_info/add_members.dart';

class GroupMembersList extends StatelessWidget {
  final String groupId;
  final UserModel currentUser;

  const GroupMembersList({
    Key? key,
    required this.groupId,
    required this.currentUser,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> getGroupMembersInfo(String groupId) async {
    List<Map<String, dynamic>> membersInfo = [];
    try {
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (groupSnapshot.exists) {
        List<dynamic> members = groupSnapshot.get('membersUid');
        String groupCreatorId = groupSnapshot.get('groupCreatorId');
        String currentUserId = FirebaseAuth.instance.currentUser!.uid;

        for (String memberId in members) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(memberId)
              .get();

          if (userSnapshot.exists) {
            var userData = userSnapshot.data() as Map<String, dynamic>;
            userData['isGroupAdmin'] = memberId == groupCreatorId;
            userData['isCurrentUser'] = memberId == currentUserId;

            membersInfo.add(userData);
          }
        }

        membersInfo.sort((a, b) {
          if (a['isCurrentUser']) return -1;
          if (b['isCurrentUser']) return 1;
          if (a['isGroupAdmin']) return -1;
          if (b['isGroupAdmin']) return 1;
          return 0;
        });
      }
    } catch (e) {
      print(e);
    }
    return membersInfo;
  }

  Future<int> getGroupMemberCount(String groupId) async {
    try {
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();
      if (groupSnapshot.exists) {
        List<dynamic> members = groupSnapshot.get('membersUid');
        return members.length;
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<int>(
                future: getGroupMemberCount(groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error',
                        style: TextStyle(color: Colors.red, fontSize: 14));
                  } else {
                    int memberCount = snapshot.data ?? 0;
                    return Text(
                      "$memberCount members",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 62, 161, 66),
              child: Icon(Icons.person_add_alt_1, color: Colors.white),
            ),
            title: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Add members',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMembers(
                    userInfo: currentUser,
                    groupId: groupId,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 62, 161, 66),
              child: Icon(Icons.link, color: Colors.white),
            ),
            title: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Invite via link',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getGroupMembersInfo(groupId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error fetching members');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No members found');
              } else {
                List<Map<String, dynamic>> membersInfo = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: membersInfo.length,
                  itemBuilder: (context, index) {
                    var member = membersInfo[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: member['imageUrl'] != null
                            ? NetworkImage(member['imageUrl'])
                            : null,
                        child: member['imageUrl'] == null
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      title: Text(
                          member['isCurrentUser'] ? 'You' : member['name']),
                      subtitle: member['status'] != null
                          ? Text(member['status'])
                          : null,
                      trailing: member['isGroupAdmin']
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF02B099),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Group Admin',
                                style: TextStyle(color: Color(0xFF02B099)),
                              ),
                            )
                          : null,
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
