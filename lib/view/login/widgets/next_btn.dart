import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/auth/login_verifying_view.dart';

class NextButton extends StatelessWidget {
  final LoginModel selectedCountry;

  const NextButton({
    Key? key,
    required this.selectedCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            if (selectedCountry.phoneNum.length == 9) {
              print("Phone Number: ${selectedCountry.phoneNum}");
              print("Country Code: ${selectedCountry.countryCode}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginVerifyingView(
                    countryCode: selectedCountry.countryCode,
                    phoneNumber: selectedCountry.phoneNum,
                  ),
                ),
              );
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
