import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/cubit/phone_auth/phone_auth_cubit.dart';

class RegisterFunction {
  final GlobalKey<FormState> phoneFormKey;
  String phoneNumber;
  String countryCode;

  RegisterFunction({
    required this.phoneFormKey,
    required this.countryCode,
    required this.phoneNumber,
  });

  Future<void> register(BuildContext context) async {
    if (!phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context)
          .submitPhoneNumber(countryCode, "595351929");
    }
  }
}
