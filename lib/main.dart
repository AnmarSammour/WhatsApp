import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Controller/cubit/login_cubit.dart';
import 'widgets/splash_screen.dart';

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
        create: (context) => LoginCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splash(),
        ),
      ),
    );
  }
}
