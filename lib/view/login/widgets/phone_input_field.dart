import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/login/widgets/country_picker_button.dart';

class PhoneInputField extends StatefulWidget {
  final LoginModel selectedCountry;

  const PhoneInputField({
    Key? key,
    required this.selectedCountry,
  }) : super(key: key);

  @override
  _PhoneInputFieldState createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CountryPickerButton.show(context);
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
                    widget.selectedCountry.countryName,
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
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '+ ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: widget.selectedCountry.countryCode,
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
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                      if (phoneNumber.length == 9) {
                        widget.selectedCountry.phoneNum = phoneNumber;
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
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
        ],
      ),
    );
  }
}
