import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/login/widgets/country_picker_button.dart';

class PhoneInputField extends StatefulWidget {
  final LoginModel selectedCountry;
  final TextEditingController phoneController;

  const PhoneInputField({
    Key? key,
    required this.selectedCountry,
    required this.phoneController,
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
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF02B099),
                ),
              ],
            ),
          ),
          Divider(
            height: 2.h,
            color: const Color(0xFF02B099),
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
                          const TextSpan(
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
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.008),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.002,
                      width: 40.w,
                      color: const Color(0xFF02B099),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.001),
                    ),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.016),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: widget.phoneController,
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                      if (phoneNumber.length == 9) {
                        widget.selectedCountry.phoneNum = phoneNumber;
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF02B099),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 9,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number cannot be empty';
                    } else if (value.length != 9) {
                      return 'Phone number must be 9 digits';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneNumber = value!;
                  },
                  onFieldSubmitted: (value) {
                    if (value.length == 9) {
                      widget.selectedCountry.phoneNum = value;
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
