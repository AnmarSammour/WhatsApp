import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/view/login/login_view.dart';

class PhoneNumberText extends StatelessWidget {
  final String countryCode;
  final String phoneNumber;

  const PhoneNumberText(
      {super.key, required this.countryCode, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 13.sp, color: Colors.black),
        children: [
          TextSpan(
            text:
                'We have sent an SMS with a code to +$countryCode $phoneNumber',
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              },
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
    );
  }
}
