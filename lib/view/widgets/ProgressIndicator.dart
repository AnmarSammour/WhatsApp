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
        content: Container(
          width: 30.w,
          height: 30.h,
          child: Row(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              SizedBox(width: 16),
              Text(
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
