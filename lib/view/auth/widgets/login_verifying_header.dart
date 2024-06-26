import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginverifyingHeader extends StatelessWidget {
  const LoginverifyingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Verifying your number',
      style: TextStyle(
        fontSize: 16.sp,
        color: const Color(0xFF02B099),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
