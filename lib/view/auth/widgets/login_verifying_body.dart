import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/view/auth/widgets/login_verifying_header.dart';
import 'package:whatsapp/view/auth/widgets/otp_text_field.dart';
import 'phone_number_text.dart';
import 'code_description_text.dart';
import 'resend_code_text.dart';

class LoginVerifyingBody extends StatelessWidget {
  final String countryCode;
  final String phoneNumber;

  LoginVerifyingBody({required this.countryCode, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          LoginverifyingHeader(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          PhoneNumberText(
            countryCode: countryCode,
            phoneNumber: phoneNumber,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          OTPTxtField(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          CodeDescriptionText(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ResendCodeText(),
        ],
      ),
    );
  }
}