import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
