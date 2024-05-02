import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';
import '../model/login_model.dart';
import 'login_verifying.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
      builder: (context, state) {
        // Initialize selectedCountry with the state's selected country if available, else with default values
        LoginModel selectedCountry = state is CountrySelectedState
            ? state.selectedCountry
            : LoginModel(
                countryCode: '970', countryName: 'Palestine', phoneNum: '');
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
                // GestureDetector for selecting country
                GestureDetector(
                  onTap: () {
                    showCountryPickerDialog(context);
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
                GestureDetector(
                  onTap: () {
                    showCountryPickerDialog(context);
                  },
                  child: Row(
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
                          keyboardType: TextInputType
                              .number, // Allow only numerical input
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
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        // Check if phone number is valid (9 digits)
                        if (selectedCountry.phoneNum.length == 9) {
                          print("Phone Number: ${selectedCountry.phoneNum}");
                          print("Country Code: ${selectedCountry.countryCode}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginVerifying(
                                countryCode: selectedCountry.countryCode,
                                phoneNumber: selectedCountry.phoneNum,
                              ),
                            ),
                          );
                        } else {
                          // Show error message if phone number is not 9 digits
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Please enter a 9-digit phone number.'),
                            ),
                          );
                        }
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
      },
    );
  }

  // Show country picker dialog
  void showCountryPickerDialog(BuildContext context) {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        final selectedCountry = LoginModel(
          countryCode: country.phoneCode,
          countryName: country.name,
          phoneNum: '',
        );
        BlocProvider.of<PhoneAuthCubit>(context).selectCountry(selectedCountry);
      },
    );
  }
}
