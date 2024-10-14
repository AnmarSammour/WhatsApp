import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

class SettingsSection extends StatelessWidget {
  final UserModel user;

  const SettingsSection({
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
          ],
        ),
      ],
    );
  }
}
