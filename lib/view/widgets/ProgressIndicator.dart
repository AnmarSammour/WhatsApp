import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressIndicatorWidget {
  static void show(BuildContext context) {
    showDialog(
      barrierColor: Colors.white.withOpacity(0.5),
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black,
        content: SizedBox(
          width: 30.w,
          height: 30.h,
          child: Row(
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              const Text(
                'Connecting...',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
