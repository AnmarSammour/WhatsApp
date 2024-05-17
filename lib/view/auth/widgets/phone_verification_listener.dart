import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/cubit/phone_auth/phone_auth_cubit.dart';

class PhoneVerificationListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is PhoneOTPVerified) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/userinfo');
        }

        if (state is ErrorOccurred) {
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
