import 'package:flutter/material.dart';

class ChatAppBarGroup extends StatelessWidget implements PreferredSizeWidget {
  final String groupName;
  final String groupImageUrl;

  const ChatAppBarGroup({
    Key? key,
    required this.groupName,
    required this.groupImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
          );
        },
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage:
                groupImageUrl.isNotEmpty ? NetworkImage(groupImageUrl) : null,
            radius: 16,
            child: groupImageUrl.isEmpty
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text(groupName, style: const TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: const Color(0xFF02B099),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      actions: const <Widget>[
        Icon(Icons.videocam_outlined),
        SizedBox(width: 10),
        Icon(Icons.call_outlined),
        SizedBox(width: 10),
        Icon(Icons.more_vert),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
