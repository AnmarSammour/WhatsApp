import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../controller/cubit/phone_auth/phone_auth_cubit.dart';

class OTPTxtField extends StatefulWidget {
  const OTPTxtField({super.key});

  @override
  _OTPTxtFieldState createState() => _OTPTxtFieldState();
}

class _OTPTxtFieldState extends State<OTPTxtField> {
  @override
  void initState() {
    super.initState();
  }

  void _checkAndSubmitOTP(String otpCode) {
    if (otpCode.length == 6) {
      setState(() {
        _login(context, otpCode);
      });
    }
  }

  void _login(BuildContext context, String otpCode) {
    BlocProvider.of<PhoneAuthCubit>(context).submitOTP(otpCode);
  }

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
                // Call function to check and submit OTP
                _checkAndSubmitOTP(value);
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
