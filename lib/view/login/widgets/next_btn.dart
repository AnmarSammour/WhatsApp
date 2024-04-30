import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/login_model.dart';
import 'register_function.dart';
import '../../widgets/ProgressIndicator.dart';

class NextButton extends StatelessWidget {
  final LoginModel selectedCountry;
  final GlobalKey<FormState> phoneFormKey;
  final bool isInvalid;

  NextButton({
    Key? key,
    required this.selectedCountry,
    required this.phoneFormKey,
    required this.isInvalid, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
              ProgressIndicatorWidget.show(context);
              RegisterFunction(
                phoneFormKey: phoneFormKey,
                countryCode: selectedCountry.countryCode,
                phoneNumber: selectedCountry.phoneNum,
              ).register(context);
            
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
