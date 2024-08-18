import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
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
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Exit group'),
            onTap: () {},
          ),
          ListTile(
            leading:
                const Icon(Icons.thumb_down_alt_outlined, color: Colors.red),
            title: const Text('Report group'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
