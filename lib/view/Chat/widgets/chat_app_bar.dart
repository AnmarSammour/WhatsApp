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
      leading: BackButton(color: Colors.white),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
            radius: 16,
          ),
          SizedBox(width: 10),
          Text(recipientName, style: TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: Color(0xFF02B099),
      actionsIconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        Icon(Icons.videocam_outlined),
        SizedBox(width: 10),
        Icon(Icons.call_outlined),
        SizedBox(width: 10),
        Icon(Icons.more_vert),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
