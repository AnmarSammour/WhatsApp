import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

class UserHeader extends StatelessWidget {
  final UserModel user;

  const UserHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(height: 8.0),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 330.0,
      elevation: 0,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var top = constraints.biggest.height;
          var isCollapsed =
              top <= kToolbarHeight + MediaQuery.of(context).padding.top;
          return FlexibleSpaceBar(
            title: isCollapsed
                ? Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: user.imageUrl.isNotEmpty
                            ? NetworkImage(user.imageUrl)
                            : null,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        radius: 15,
                        child: user.imageUrl.isEmpty
                            ? Icon(Icons.person, size: 20, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.name,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  )
                : null,
            background: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  backgroundImage: user.imageUrl.isNotEmpty
                      ? NetworkImage(user.imageUrl)
                      : null,
                  child: user.imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.phoneNumber,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.message, 'Message'),
                    _buildActionButton(Icons.call, 'Audio'),
                    _buildActionButton(Icons.videocam, 'Video'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }
}
