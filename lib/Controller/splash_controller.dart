import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whatsapp/View/lock_screen.dart';


class SplashController {
  SplashController(BuildContext context) {
    Timer(Duration(seconds: 3), () {
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Lockscreen()),
      );
    });
  }
}
