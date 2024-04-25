import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
