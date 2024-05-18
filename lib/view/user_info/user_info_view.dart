import 'package:flutter/material.dart';
import 'package:whatsapp/view/user_info/widgets/user_info_view_body.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: UserInfoViewBody(),
    );
  }
}
