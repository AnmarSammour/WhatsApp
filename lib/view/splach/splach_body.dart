import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/login_screen.dart';

class SplashBody extends StatefulWidget {
  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  @override
  void initState() {
    super.initState();
    // Set a timer to navigate to the login screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SplachViewBody(),
    );
  }
}

class SplachViewBody extends StatelessWidget {
  const SplachViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
          ),
          // Display the app icon
          CustomSplachImg(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
          ),
          CustomSplachFoter(),
        ],
      ),
    );
  }
}

class CustomSplachImg extends StatelessWidget {
  const CustomSplachImg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/WhatsAppIcon.png',
      width: 100.w,
      height: 100.h,
    );
  }
}

class CustomSplachFoter extends StatelessWidget {
  const CustomSplachFoter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'from',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
          ),
        ),
        Text(
          'FACEBOOK',
          style: TextStyle(
            color: const Color(0xFF02B099),
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }
}
