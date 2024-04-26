import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResendCodeText extends StatelessWidget {
  const ResendCodeText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        'Didn\'t receive code?',
        style: TextStyle(
          color: const Color(0xFF02B099),
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
