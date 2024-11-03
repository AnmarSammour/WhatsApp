import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String recipientName;
  final String imageUrl;

  const ChatAppBar({
    Key? key,
    required this.recipientName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(color: Colors.white),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            radius: 16,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text(recipientName, style: const TextStyle(color: Colors.white)),
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
