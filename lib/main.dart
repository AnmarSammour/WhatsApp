import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller/cubit/phone_auth/phone_auth_cubit.dart';
import 'view/home/home_view.dart';
import 'view/login/login_view.dart';
import 'view/splach/splach_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // أو أي عنصر تحميل آخر
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return ScreenUtilInit(
          designSize: Size(360, 640),
          builder: (context, _) => BlocProvider(
            create: (context) => PhoneAuthCubit(),
            child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: '/splach',
              home: SplachView(),
              routes: {
                '/splach': (context) => SplachView(),
                '/login': (context) => LoginView(),
                '/home': (context) => HomeView(),
              },
            ),
          ),
        );
      },
    );
  }

  Future<String> _getInitialRoute() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return '/login';
    } else {
      return '/home';
    }
  }
}
