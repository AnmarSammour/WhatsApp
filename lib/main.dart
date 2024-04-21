import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/View/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 640), 
      builder: (context, _) => MaterialApp( 
        debugShowCheckedModeBanner: false,
        home: Splash(), 
      ),
    );
  }
}
