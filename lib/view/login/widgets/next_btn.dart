import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/login/widgets/register_function.dart';
import 'package:whatsapp/view/widgets/ProgressIndicator.dart';

class NextButton extends StatelessWidget {
  final LoginModel selectedCountry;
  final GlobalKey<FormState> phoneFormKey; // تعريف المفتاح هنا

  NextButton({
    Key? key,
    required this.selectedCountry,
    required this.phoneFormKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            if (selectedCountry.phoneNum.length == 9) {
              ProgressIndicatorWidget().showProgressIndicator(context);
              // تمرير المفتاح هنا
              RegisterFunction(phoneFormKey: phoneFormKey).register(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter a 9-digit phone number.'),
                ),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF02B099)),
          ),
          child: Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
