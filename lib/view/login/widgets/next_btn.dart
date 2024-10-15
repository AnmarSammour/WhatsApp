import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/login_model.dart';
import 'register_function.dart';
import '../../widgets/ProgressIndicator.dart';

class NextButton extends StatelessWidget {
  final LoginModel selectedCountry;
  final GlobalKey<FormState> phoneFormKey;
  final bool isInvalid;
  final TextEditingController phoneController;
  NextButton({
    Key? key,
    required this.selectedCountry,
    required this.phoneFormKey,
    required this.isInvalid,
    required this.phoneController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            if (phoneFormKey.currentState!.validate()) {
              selectedCountry.phoneNum = phoneController.text;
              ProgressIndicatorWidget.show(context);
              RegisterFunction(
                phoneFormKey: phoneFormKey,
                countryCode: selectedCountry.countryCode,
                phoneNumber: selectedCountry.phoneNum,
              ).register(context);
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFF02B099)),
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
