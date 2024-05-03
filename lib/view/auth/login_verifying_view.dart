import 'package:flutter/material.dart';
import 'widgets/login_verifying_body.dart';

class LoginVerifyingView extends StatelessWidget {
  final String countryCode;
  final String phoneNumber;

  LoginVerifyingView({required this.countryCode, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginVerifyingBody(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      ),
    );
  }
}
