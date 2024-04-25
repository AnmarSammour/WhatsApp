import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/view/splach/widgets/splach_view_body.dart';

import '../../widgets/login_screen.dart';

class SpachView extends StatefulWidget {
  const SpachView({super.key});

  @override
  State<SpachView> createState() => _SpachViewState();
}

class _SpachViewState extends State<SpachView> {
  @override
  void initState() {
    super.initState();
    // Set a timer to navigate to the login screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SplachViewBody(),
    );
  }
}
