import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  CustomFAB({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Color(0xFF02B099),
      child: Icon(icon, color: Colors.white),
    );
  }
}
