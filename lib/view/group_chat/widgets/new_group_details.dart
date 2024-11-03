import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller/cubit/group_chat/group_chat_cubit.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/Chat/widgets/emoji_picker.dart';
import 'package:whatsapp/view/group_chat/widgets/chat_group_view.dart';
import 'package:whatsapp/view/widgets/custom_fab.dart';

class NewGroupDetails extends StatefulWidget {
  final List<UserModel> selectedContacts;
  final String senderName;
  final String senderUID;

  const NewGroupDetails({
    Key? key,
    required this.selectedContacts,
    required this.senderName,
    required this.senderUID,
  }) : super(key: key);

  @override
  _NewGroupDetailsState createState() => _NewGroupDetailsState();
}

class _NewGroupDetailsState extends State<NewGroupDetails> {
  String groupName = '';
  File? profilePic;
  bool isEmojiPickerVisible = false;
  final TextEditingController _groupNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profilePic = File(pickedFile.path);
      });
    }
  }

  void _toggleEmojiPicker() {
    if (isEmojiPickerVisible) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
    setState(() {
      isEmojiPickerVisible = !isEmojiPickerVisible;
    });
  }

  void _onEmojiSelected(Emoji emoji) {
    _groupNameController.text += emoji.emoji;
    setState(() {
      groupName = _groupNameController.text;
    });
  }

  Future<void> _createGroupAndNavigate() async {
    final senderId = widget.senderUID;
    final senderName = widget.senderName;

    if (groupName.isEmpty) {
      groupName =
          'You, ${widget.selectedContacts.map((user) => user.name).join(', ')}';
    }

    String groupId = '';
    try {
      groupId = await context.read<GroupChatCubit>().createGroup(
            senderName: senderName,
            groupName: groupName,
            profilePic: profilePic,
            membersUid: widget.selectedContacts.map((user) => user.id).toList(),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create group: $e')),
      );
      return;
    }

    if (mounted) {
      if (groupId.isNotEmpty) {
        final memberIds = [
          senderId,
          ...widget.selectedContacts.map((user) => user.id),
        ];

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ChatGroupView(
              groupId: groupId,
              groupName: groupName,
              memberIds: memberIds,
              groupImageUrl: profilePic != null ? profilePic!.path : '',
            ),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create group')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          profilePic != null ? FileImage(profilePic!) : null,
                      child: profilePic == null
                          ? const Icon(Icons.group, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _groupNameController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: 'Group name (optional)',
                        border: InputBorder.none,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF02B099), width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isEmojiPickerVisible
                              ? Icons.keyboard
                              : Icons.insert_emoticon),
                          onPressed: _toggleEmojiPicker,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          groupName = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Disappearing messages'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Group permissions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Members: ${widget.selectedContacts.length}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.selectedContacts.length,
                itemBuilder: (context, index) {
                  UserModel user = widget.selectedContacts[index];
                  return SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: user.imageUrl.isNotEmpty
                              ? NetworkImage(user.imageUrl)
                              : null,
                          child: user.imageUrl.isEmpty
                              ? const Icon(Icons.person,
                                  size: 30, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(user.name, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: isEmojiPickerVisible,
              child: EmojiPickerWidget(
                onEmojiSelected: _onEmojiSelected,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFAB(
        onPressed: _createGroupAndNavigate,
        icon: Icons.check,
        heroTag: 'confirmGroupDetails',
      ),
    );
  }
}
