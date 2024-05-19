import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/app_routes.dart';

void main() async {
  //Initialize widget binding before configuring Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrap the app with ScreenUtilInit to enable screen adaptation
    return ScreenUtilInit(
      designSize: Size(360, 640),
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider<PhoneAuthCubit>(create: (context) => PhoneAuthCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false, // Disable debug banner
          theme: ThemeData(
            primarySwatch: Colors.blue, // Set the primary color theme
          ),
          initialRoute: AppRoutes.splash, //initial screen to the splash view
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}
