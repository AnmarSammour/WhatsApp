import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Controller/login_controller.dart';
import '../Model/country_model.dart';
import '../Model/login_verifyingc_model .dart';

class LogIn extends StatefulWidget {
  final LogInController controller;

  LogIn({required this.controller});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late CountryModel selectedCountry;
LoginVerifyingModel loginVerifyingModel = LoginVerifyingModel(
  phoneNumber: '',
  verificationCode: '',
);
  @override
  void initState() {
    super.initState();
    selectedCountry = widget.controller.selectedCountry;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your phone number',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 13.sp, color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        'WhatsApp will need to verify your phone number. Carrier charges may apply. ',
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'What\'s my number?',
                        style: TextStyle(
                          color: Color(0xFF02B099),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            GestureDetector(
              onTap: () {
                widget.controller.showCountryPickerDialog(context, (country) {
                  setState(() {
                    selectedCountry = country;
                  });
                });
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    height: 48.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedCountry.countryName,
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF02B099),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 2.h,
                    color: Color(0xFF02B099),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                          children: [
                            TextSpan(
                              text: '+ ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: selectedCountry.countryCode,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 2.h,
                        width: 40.w,
                        color: Color(0xFF02B099),
                        margin: EdgeInsets.only(bottom: 1.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'phone number',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF02B099),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    widget.controller.navigateToLoginVerifyingPage(context,loginVerifyingModel);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF02B099)),
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
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ],
        ),
      ),
    );
  }
}
