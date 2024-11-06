import 'package:flutter/material.dart';

class MetaOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const MetaOption({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }
}
