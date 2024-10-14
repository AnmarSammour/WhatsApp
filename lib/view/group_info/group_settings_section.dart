import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

class GroupSettingsSection extends StatelessWidget {
  final UserModel user;

  const GroupSettingsSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Media, links, and docs',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '0',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          onTap: () {},
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 5,
        ),
        Column(
          children: [
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Notifications'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.photo_outlined),
              title: Text('Media visibility'),
              onTap: () {},
            ),
          ],
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 5,
        ),
        Column(
          children: [
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Encryption'),
              subtitle: Text(
                  'Messages and calls are end-to-end encrypted. Tap to verify.'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history_toggle_off_sharp),
              title: Text('Disappearing messages'),
              subtitle: Text('Off'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock_outline_sharp),
              title: Text('Chat lock'),
              subtitle: Text('Lock and hide this chat on this device.'),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Group permissions'),
              onTap: () {},
            ),
          ],
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF02B099),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.groups_2_rounded,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              title: const Text(
                'Add group to a community',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Bring members together in topic-based groups',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
