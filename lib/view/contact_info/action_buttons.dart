import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

class ActionButtons extends StatelessWidget {
  final UserModel user;

  const ActionButtons({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite_border_outlined),
            title: const Text('Add to Favorites'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.red),
            title: Text('Block ${user.name}'),
            onTap: () {},
          ),
          ListTile(
            leading:
                const Icon(Icons.thumb_down_alt_outlined, color: Colors.red),
            title: Text('Report ${user.name}'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
