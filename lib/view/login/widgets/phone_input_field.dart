import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/login/widgets/country_picker_button.dart';

class PhoneInputField extends StatelessWidget {
  final LoginModel selectedCountry;

  const PhoneInputField({
    Key? key,
    required this.selectedCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GestureDetector for selecting country
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Display country code
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
                  onChanged: (value) {
                    // Validate phone number length
                    if (value.length == 9) {
                      selectedCountry.phoneNum = value;
                    } else {
                      // Reset phone number if it's not 9 digits
                      selectedCountry.phoneNum = '';
                    }
                  },
                  keyboardType:
                      TextInputType.number, // Allow only numerical input
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
        ],
      ),
    );
  }
}
