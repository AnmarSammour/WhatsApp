import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Model/login_verifyingc_model .dart';

class LoginVerifying extends StatelessWidget {
  final LoginVerifyingModel loginVerifyingModel;

  LoginVerifying({required this.loginVerifyingModel});

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
                  fontWeight: FontWeight.bold),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOtpTextField(),
                SizedBox(width: 8),
                buildOtpTextField(),
                SizedBox(width: 8),
                buildOtpTextField(),
                SizedBox(width: 24),
                buildOtpTextField(),
                SizedBox(width: 8),
                buildOtpTextField(),
                SizedBox(width: 8),
                buildOtpTextField(),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              width: 150,
              height: 2.h,
              color: Colors.grey,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
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

  Widget buildOtpTextField() {
    return Container(
      width: 10,
      height: 20,
      child: TextField(
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length > 1) {
            value = value.substring(0, 1);
          }
        },
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
    );
  }
}
