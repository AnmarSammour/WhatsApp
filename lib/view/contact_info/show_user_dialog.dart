import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

void showUserDialog(BuildContext context, UserModel user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: user.imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(user.imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: user.imageUrl.isEmpty
                          ? Colors.grey.shade300
                          : Colors.transparent,
                    ),
                    child: user.imageUrl.isEmpty
                        ? const Center(
                            child: Icon(Icons.person,
                                size: 100, color: Colors.white))
                        : null,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.black.withOpacity(0.5),
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.message, color: Colors.green),
                    onPressed: () {
                      // Navigate to chat screen
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () {
                      // Start a call
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.green),
                    onPressed: () {
                      // Start a video call
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
