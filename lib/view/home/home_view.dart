import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/home/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  final UserModel userInfo;

  const HomeView({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeViewBody(userInfo: widget.userInfo),
    );
  }
}
