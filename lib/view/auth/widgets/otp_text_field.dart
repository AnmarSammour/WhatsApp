import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OTPTxtField extends StatelessWidget {
  const OTPTxtField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          // OTPTextField for entering verification code
          child: OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            textFieldAlignment: MainAxisAlignment.center,
            fieldWidth: 10,
            fieldStyle: FieldStyle.underline,
            style: TextStyle(fontSize: 16.sp),
            margin: EdgeInsets.all(8),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Container(
          width: 160.w,
          height: 2.h,
          color: Colors.grey,
        ),
      ],
    );
  }
}
