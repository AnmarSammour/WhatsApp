import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp/view/splach/splach_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrap the app with ScreenUtilInit to enable screen adaptation
    return ScreenUtilInit(
      designSize: Size(360, 640),
      builder: (context, _) => BlocProvider(
        create: (context) => PhoneAuthCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplachView(),
        ),
      ),
    );
  }
}
