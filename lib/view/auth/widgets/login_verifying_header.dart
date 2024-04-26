import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginVerifyingHeader extends StatelessWidget {
  const LoginVerifyingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Verifying your number',
      style: TextStyle(
        fontSize: 16.sp,
        color: Color(0xFF02B099),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
