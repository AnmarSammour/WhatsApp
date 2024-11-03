import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/user/user_cubit.dart';
import 'package:whatsapp/controller/cubit/user/user_state.dart';
import 'package:whatsapp/view/Chat/chat_screen_view.dart';
import 'package:whatsapp/view/home/home_view.dart';
import 'package:whatsapp/view/user_info/user_info_view.dart';
import 'package:whatsapp/view/login/login_view.dart';
import 'package:whatsapp/view/splach/splach_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String userInfo = '/userinfo';
  static const String chat = '/chat';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplachView());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case userInfo:
        return MaterialPageRoute(builder: (_) => const UserInfo());
      case chat:
        return MaterialPageRoute(builder: (context) {
          return BlocProvider(
            create: (context) => UserCubit(),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return ChatView(userInfo: state.user.first);
                } else if (state is UserError) {
                  return Scaffold(
                      body: Center(child: Text(state.errorMessage)));
                } else {
                  return Container();
                }
              },
            ),
          );
        });
      case home:
        return MaterialPageRoute(builder: (context) {
          return BlocProvider(
            create: (context) => UserCubit(),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return HomeView(userInfo: state.user.first);
                } else if (state is UserError) {
                  return Scaffold(
                      body: Center(child: Text(state.errorMessage)));
                } else {
                  return Container();
                }
              },
            ),
          );
        });
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
