import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/login/widgets/register_function.dart';
import 'package:whatsapp/view/widgets/ProgressIndicator.dart';

class ResendCodeText extends StatelessWidget {
  final LoginModel selectedCountry;
  final GlobalKey<FormState> phoneFormKey;

  ResendCodeText({
    Key? key,
    required this.selectedCountry,
    required this.phoneFormKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProgressIndicatorWidget.show(context);
        RegisterFunction(
          phoneFormKey: phoneFormKey,
          countryCode: selectedCountry.countryCode,
          phoneNumber: selectedCountry.phoneNum,
        ).resendCode(context);
      },
      child: Text(
        'Didn\'t receive code?',
        style: TextStyle(
          color: const Color(0xFF02B099),
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
