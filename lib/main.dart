import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/controller/cubit/chat/chat_cubit.dart';
import 'package:whatsapp/controller/cubit/communication/communication_cubit.dart';
import 'package:whatsapp/controller/cubit/group_chat/group_chat_cubit.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp/controller/cubit/status/status_cubit.dart';
import 'package:whatsapp/controller/cubit/user/user_cubit.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/app_routes.dart';

void main() async {
  // Initialize widget binding before configuring Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with ScreenUtilInit to enable screen adaptation
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider<PhoneAuthCubit>(create: (context) => PhoneAuthCubit()),
          BlocProvider<UserCubit>(create: (context) => UserCubit()),
          BlocProvider<ChatCubit>(
              create: (context) => ChatCubit(
                    firestore: FirebaseFirestore.instance,
                  )),
          BlocProvider<CommunicationCubit>(
              create: (context) => CommunicationCubit(
                  firestore: FirebaseFirestore.instance,
                  storage: FirebaseStorage.instance)),
          BlocProvider<StatusCubit>(create: (context) => StatusCubit()),
          BlocProvider<GroupChatCubit>(
              create: (context) => GroupChatCubit(
                    firestore: FirebaseFirestore.instance,
                    storage: FirebaseStorage.instance,
                    auth: FirebaseAuth.instance,
                  )),
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
