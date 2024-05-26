import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final int currentPageIndex;
  final Function(int) onTabTapped;

  const CustomAppBar({
    required this.tabController,
    required this.currentPageIndex,
    required this.onTabTapped,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF02B099),
      title: Text('WhatsApp', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
      bottom: TabBar(
        controller: tabController,
        indicatorColor: Colors.white,
        tabs: const [
          Icon(Icons.group, color: Colors.white),
          Text('CHATS', style: TextStyle(color: Colors.white)),
          Text('STATUS', style: TextStyle(color: Colors.white)),
          Text('CALLS', style: TextStyle(color: Colors.white)),
        ],
        onTap: onTabTapped,
      ),
    );
  }
}
