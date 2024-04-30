import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controller/cubit/phone_auth/phone_auth_cubit.dart';
import '../../../model/login_model.dart';
import 'login_header.dart';
import 'next_btn.dart';
import 'phone_input_field.dart';
import 'phone_num_submited.dart';

class LoginViewBody extends StatefulWidget {
  @override
  _LoginViewBodyState createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  bool _isInvalid = false; 

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
          body: Form(
            key: phoneFormKey,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  LoginHeader(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  PhoneInputField(
                    selectedCountry: selectedCountry,
                    onPhoneNumberChanged: (phoneNumber) {
                      selectedCountry.phoneNum =
                          phoneNumber; // Update the phone number
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  NextButton(
                    selectedCountry: selectedCountry,
                    phoneFormKey: phoneFormKey,
                    isInvalid: _isInvalid,
                  ),
                  PhoneSubmitWidget(selectedCountry: selectedCountry),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
