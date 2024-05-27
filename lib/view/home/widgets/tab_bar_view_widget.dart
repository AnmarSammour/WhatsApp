import 'package:flutter/material.dart';
import 'package:whatsapp/view/Chat/chat_screen_view.dart';
import 'package:whatsapp/view/call/call_view.dart';
import 'package:whatsapp/view/communities/communities_view.dart';
import 'package:whatsapp/view/status/status_view.dart';
class CustomTabBarView extends StatelessWidget {
  final TabController tabController;

  CustomTabBarView({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        CommunitiesView(),
        ChatScreen(),
        StatusView(),
        CallView(),
      ],
    );
  }
}
