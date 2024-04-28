import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp/model/login_model.dart';
import 'package:whatsapp/view/auth/login_verifying_view.dart';

class PhoneSubmitWidget extends StatelessWidget {
  final LoginModel selectedCountry;

  const PhoneSubmitWidget({super.key, required this.selectedCountry});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {

        if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginVerifyingView(
                countryCode: selectedCountry.countryCode,
                phoneNumber: selectedCountry.phoneNum,
              ),
            ),
          );
        }

        if (state is ErrorOccurred) {
          Navigator.pop(context);
          String errorMsg = (state).errorMsg;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }
}
