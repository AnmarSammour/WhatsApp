import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Object? heroTag;

  CustomFAB({
    required this.onPressed,
    required this.icon,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF02B099),
      heroTag: heroTag,
      child: Icon(icon, color: Colors.white),
    );
  }
}
