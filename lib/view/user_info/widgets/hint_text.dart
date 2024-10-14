import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HintText extends StatelessWidget {
  const HintText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      'Please provide your name and an optional profile photo',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 20.sp,
      ),
    );
  }
}
