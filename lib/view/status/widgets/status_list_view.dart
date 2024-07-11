import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/status/status_cubit.dart';
import 'package:whatsapp/model/status.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/status/widgets/custom_story_avatar.dart';
import 'package:whatsapp/view/status/widgets/story_view.dart';

class StatusListView extends StatelessWidget {
  final String userId;
  final List<Status> statuses;

  const StatusListView({Key? key, required this.userId, required this.statuses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: context.read<StatusCubit>().fetchUser(userId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (userSnapshot.hasError) {
          return const Center(child: Text('Error fetching user data'));
        } else if (!userSnapshot.hasData) {
          return const Center(child: Text('User not found'));
        } else {
          UserModel user = userSnapshot.data!;
          return Column(
            children: [
              ListTile(
                leading: CustomStoryAvatar(user: user, statuses: statuses),
                title: Text(user.name),
                subtitle: Text(_formatTimestamp(statuses)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryViewScreen(
                        statuses: statuses,
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  String _formatTimestamp(List<Status> statuses) {
    if (statuses.isNotEmpty) {
      Duration timeAgo = DateTime.now().difference(statuses.first.timestamp);
      if (timeAgo.inSeconds < 60) {
        return '${timeAgo.inSeconds} seconds ago';
      } else if (timeAgo.inMinutes < 60) {
        return '${timeAgo.inMinutes} minutes ago';
      } else if (timeAgo.inHours < 24) {
        return '${timeAgo.inHours} hours ago';
      } else {
        return '${timeAgo.inDays} days ago';
      }
    }
    return 'No status available';
  }
}
