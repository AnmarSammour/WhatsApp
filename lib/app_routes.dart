import 'package:flutter/material.dart';
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
        return MaterialPageRoute(builder: (_) => SplachView());
      case login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case userInfo:
        return MaterialPageRoute(builder: (_) => UserInfo());
      case chat:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => HomeView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
