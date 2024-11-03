import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

class GroupSection extends StatelessWidget {
  final UserModel user;

  const GroupSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No groups in common',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.group_add, color: Colors.white),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Create group with ${user.name}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
