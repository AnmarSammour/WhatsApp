import 'package:flutter/material.dart';

class UserNameField extends StatelessWidget {
  final TextEditingController controller;

  const UserNameField({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Type your name here',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF02B099),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF02B099),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }
}
