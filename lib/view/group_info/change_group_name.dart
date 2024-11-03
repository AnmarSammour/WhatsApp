import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/group_chat/group_chat_cubit.dart';

class ChangeGroupName extends StatefulWidget {
  final String groupId;
  final String initialGroupName;

  const ChangeGroupName({
    Key? key,
    required this.groupId,
    required this.initialGroupName,
  }) : super(key: key);

  @override
  _ChangeGroupNameState createState() => _ChangeGroupNameState();
}

class _ChangeGroupNameState extends State<ChangeGroupName> {
  late TextEditingController _groupNameController;
  bool _isEditing = false;
  int _remainingChars = 100;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(text: widget.initialGroupName);
    _remainingChars = 100 - widget.initialGroupName.length;
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter group name'),
        automaticallyImplyLeading: false,
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _groupNameController,
              maxLength: 100,
              onChanged: (text) {
                setState(() {
                  _remainingChars = 100 - text.length;
                });
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isEditing ? const Color(0xFF02B099) : Colors.grey,
                  ),
                ),
                hintText: 'Group name ',
                hintStyle: const TextStyle(color: Colors.grey),
                counterText: '',
                suffixText: ' $_remainingChars',
                suffixStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                suffixIcon: const Icon(Icons.emoji_emotions_outlined,
                    color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.right,
              onTap: () {
                setState(() {
                  _isEditing = true;
                });
              },
              onEditingComplete: () {
                setState(() {
                  _isEditing = false;
                });
              },
            ),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color(0xFF02B099), fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: _groupNameController.text.isEmpty
                          ? null
                          : () {
                              context.read<GroupChatCubit>().updateGroupName(
                                    groupId: widget.groupId,
                                    newGroupName: _groupNameController.text,
                                  );
                              Navigator.of(context).pop();
                            },
                      style: TextButton.styleFrom(
                        foregroundColor: _groupNameController.text.isEmpty
                            ? Colors.grey
                            : const Color(0xFF02B099),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
