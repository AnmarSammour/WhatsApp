import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  final UserModel user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(left: 20, right: 10),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(.3),
        radius: 20,
        backgroundImage:
            user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl) : null,
        child: user.imageUrl.isEmpty
            ? const Icon(Icons.person, size: 30, color: Colors.white)
            : null,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      subtitle: const Text(
        "Hey there! I'm using WhatsApp",
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
      ),
    );
  }
}
