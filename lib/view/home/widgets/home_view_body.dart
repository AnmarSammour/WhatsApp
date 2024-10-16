import 'package:flutter/material.dart';
import 'app_bar_widget.dart';
import 'tab_bar_view_widget.dart';
import 'package:whatsapp/model/user.dart';

class HomeViewBody extends StatefulWidget {
  final UserModel userInfo;

  const HomeViewBody({super.key, required this.userInfo});

  @override
  _HomeViewBodyState createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: 4, initialIndex: currentPageIndex, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tabController: tabController,
        currentPageIndex: currentPageIndex,
        onTabTapped: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentUser: widget.userInfo,
      ),
      body: CustomTabBarView(
          tabController: tabController, userInfo: widget.userInfo),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
