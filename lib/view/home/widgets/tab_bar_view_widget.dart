import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/Chat/chat_screen_view.dart';
import 'package:whatsapp/view/call/call_view.dart';
import 'package:whatsapp/view/communities/communities_view.dart';
import 'package:whatsapp/view/status/status_view.dart';

class CustomTabBarView extends StatelessWidget {
  final TabController tabController;
  final UserModel userInfo;

  const CustomTabBarView(
      {super.key, required this.tabController, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        const CommunitiesView(),
        ChatView(userInfo: userInfo),
        StatusView(userInfo: userInfo),
        const CallView(),
      ],
    );
  }
}
