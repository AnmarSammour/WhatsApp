import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/controller/cubit/login_cubit.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/login/widgets/login_header.dart';
import 'package:whatsapp/view/login/widgets/next_btn.dart';
import 'package:whatsapp/view/login/widgets/phone_input_field.dart';

class LoginViewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
                LoginHeader(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                PhoneInputField(selectedCountry: selectedCountry),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                NextButton(selectedCountry: selectedCountry),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ],
            ),
          ),
        );
      },
    );
  }
}
