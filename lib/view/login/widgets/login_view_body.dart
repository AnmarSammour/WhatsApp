import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/view/login/widgets/whats_my_num.dart';
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
  final bool _isInvalid = false;
  late ValueNotifier<LoginModel> selectedCountry;
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCountry = ValueNotifier<LoginModel>(
      LoginModel(
        countryCode: '970',
        countryName: 'Palestine',
        phoneNum: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
      builder: (context, state) {
        if (state is CountrySelectedState) {
          selectedCountry.value = state.selectedCountry;
        }

        return Scaffold(
          body: Form(
            key: phoneFormKey,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const LoginHeader(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.067),
                  WhatsMynum(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.067),
                  PhoneInputField(
                    selectedCountry: selectedCountry.value,
                    phoneController: phoneController,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.067),
                  NextButton(
                    selectedCountry: selectedCountry.value,
                    phoneFormKey: phoneFormKey,
                    phoneController: phoneController,
                    isInvalid: _isInvalid,
                  ),
                  PhoneSubmitWidget(selectedCountry: selectedCountry.value),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.067),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
