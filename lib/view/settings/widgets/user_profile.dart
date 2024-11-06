// user_profile.dart
import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/settings/widgets/profile_settings.dart';

class UserProfile extends StatelessWidget {
  final UserModel user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.imageUrl)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name),
              const SizedBox(height: 4),
              Text(user.status, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const Row(
            children: [
              Icon(Icons.qr_code, size: 20, color: Color(0xFF02B099)),
              SizedBox(width: 8),
              Icon(Icons.expand_circle_down_outlined,
                  size: 20, color: Color(0xFF02B099)),
            ],
          ),
        ],
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSettings()),
        );
      },
    );
  }
}
