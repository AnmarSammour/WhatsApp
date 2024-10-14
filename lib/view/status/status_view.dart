import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/status/widgets/status_view_body.dart';

class StatusView extends StatelessWidget {
  final UserModel userInfo;

  const StatusView({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StatusViewBody(userInfo: userInfo),
    );
  }
}
