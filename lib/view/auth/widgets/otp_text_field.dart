import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OTPTxtField extends StatelessWidget {
  late String otpCode;

  OTPTxtField({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          // PinCodeTextField for entering verification code
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: PinCodeTextField(
              length: 6,
              mainAxisAlignment: MainAxisAlignment.center,
              textStyle: TextStyle(fontSize: 16.sp),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                inactiveColor: Colors.grey,
                activeColor: Colors.black,
                fieldWidth: 10.w,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                print(value);
              },
              onCompleted: (submitedCode) {
                otpCode = submitedCode;
              },
              separatorBuilder: (context, index) => SizedBox(width: 10.w),
              appContext: context,
            ),
          ),
        ),
        Container(
          width: 160.w,
          height: 2.h,
          color: Colors.grey,
        ),
      ],
    );
  }
}
