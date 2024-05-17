import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/model/login_model.dart';
import 'login_verifying_header.dart';
import 'otp_text_field.dart';
import 'phone_verification_listener.dart';
import 'phone_number_text.dart';
import 'code_description_text.dart';
import 'resend_code_text.dart';

// ignore: must_be_immutable
class LoginVerifyingBody extends StatelessWidget {
  final String countryCode;
  final String phoneNumber;
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  late LoginModel selectedCountry = LoginModel(countryCode: '', countryName: ''); // تعيين قيمة افتراضية

  LoginVerifyingBody({required this.countryCode, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          LoginverifyingHeader(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          PhoneNumberText(
            countryCode: countryCode,
            phoneNumber: phoneNumber,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          OTPTxtField(),
          PhoneVerificationListener(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          CodeDescriptionText(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ResendCodeText(
            selectedCountry: selectedCountry,
            phoneFormKey: phoneFormKey,
          ),
        ],
      ),
    );
  }
}