import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class LoginVerifying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              'Verifying your number',
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF02B099),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 13.sp, color: Colors.black),
                children: [
                  const TextSpan(
                    text:
                        'We have sent an SMS with a code to +970 xx-xxx-xxxx.',
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Wrong number?',
                        style: TextStyle(
                          color: const Color(0xFF02B099),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Center(
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Text(
              'Enter 6-digit code',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Didn\'t receive code?',
                style: TextStyle(
                  color: const Color(0xFF02B099),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
