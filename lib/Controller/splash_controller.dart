import 'dart:async';
import 'package:flutter/material.dart';
import '../Controller/login_controller.dart';
import '../View/login_screen.dart'; 
class SplashController {
  SplashController(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn(controller: LogInController())), 
      );
    });
  }
}
