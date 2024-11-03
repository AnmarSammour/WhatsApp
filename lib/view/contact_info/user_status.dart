import 'package:flutter/material.dart';

class UserStatus extends StatelessWidget {
  final String phoneNumber;
  final Future<String> Function(String) getUserStatus;

  const UserStatus({
    Key? key,
    required this.phoneNumber,
    required this.getUserStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserStatus(phoneNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              title: Text('Loading...'),
            ),
          );
        } else if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              title: Text('Error fetching status'),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              title: Text(snapshot.data ?? 'No status available'),
            ),
          );
        }
      },
    );
  }
}
