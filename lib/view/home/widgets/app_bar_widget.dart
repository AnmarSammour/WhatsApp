import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/home/widgets/Custom_search_delegate.dart';
import 'package:whatsapp/view/home/widgets/custom_pop_up_menu_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final int currentPageIndex;
  final Function(int) onTabTapped;
  final UserModel currentUser;

  const CustomAppBar({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onTabTapped,
    required this.currentUser,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF02B099),
      title: const Text('WhatsApp', style: TextStyle(color: Color(0xffEEF0F1))),
      actions: [
        IconButton(
          icon: const Icon(Icons.camera_alt_outlined, color: Color(0xffEEF0F1)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xffEEF0F1)),
          onPressed: () {
            showSearchPage(context);
          },
        ),
        CustomPopupMenuButton(
          currentUser: currentUser,
        ),
      ],
      bottom: TabBar(
        controller: tabController,
        indicatorColor: const Color(0xffEEF0F1),
        tabs: const [
          Icon(Icons.group, color: Color(0xffEEF0F1)),
          Text('CHATS', style: TextStyle(color: Color(0xffEEF0F1))),
          Text('STATUS', style: TextStyle(color: Color(0xffEEF0F1))),
          Text('CALLS', style: TextStyle(color: Color(0xffEEF0F1))),
        ],
        onTap: onTabTapped,
      ),
    );
  }

  void showSearchPage(BuildContext context) {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(currentUser: currentUser),
    );
  }
}
