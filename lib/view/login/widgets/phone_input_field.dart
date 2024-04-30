import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/login_model.dart';
import 'country_picker_button.dart';

class PhoneInputField extends StatefulWidget {
  final LoginModel selectedCountry;
  final void Function(String) onPhoneNumberChanged; 

  const PhoneInputField({
    Key? key,
    required this.selectedCountry,
    required this.onPhoneNumberChanged,
  }) : super(key: key);

  @override
  _PhoneInputFieldState createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return GestureDetector(
      onTap: () {
        CountryPickerButton.show(context);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                child: TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF02B099),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number cannot be empty';
                    } else if (value.length != 9) {
                      return 'Phone number must be 9 digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      widget.onPhoneNumberChanged(
                          value); // Invoke the callback function
                    });
                  },
                  onFieldSubmitted: (value) {
                    // Check if the entered phone number is valid
                    if (value.length == 9) {
                      // Update the phone number in selectedCountry
                      widget.onPhoneNumberChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
