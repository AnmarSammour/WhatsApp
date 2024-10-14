import 'package:flutter/material.dart';
import 'package:whatsapp/model/status.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/status/widgets/story_progress_painter.dart';

class CustomStoryAvatar extends StatelessWidget {
  final UserModel user;
  final List<Status> statuses;
  final bool viewed;

  const CustomStoryAvatar({
    super.key,
    required this.user,
    required this.statuses,
    this.viewed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage:
                user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl) : null,
            child: user.imageUrl.isEmpty
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: StoryProgressPainter(
              total: statuses.length,
              viewed: viewed,
            ),
          ),
        ),
      ],
    );
  }
}
