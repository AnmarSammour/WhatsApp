import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';

class RegisterFunction {
  final GlobalKey<FormState> phoneFormKey;
  late String phoneNumber;
  late String countryCode;

  RegisterFunction({required this.phoneFormKey});

  Future<void> register(BuildContext context) async {
    if (!phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context)
          .submitPhoneNumber("970", "569225219");
    }
  }
}
