import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller/cubit/status/status_cubit.dart';
import 'package:whatsapp/model/status.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/status/widgets/edit_story.dart';

class MyStatus extends StatelessWidget {
  final UserModel userInfo;

  const MyStatus({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: userInfo.imageUrl.isNotEmpty
                ? NetworkImage(userInfo.imageUrl)
                : null,
            radius: 30,
            child: userInfo.imageUrl.isEmpty
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFF02B099),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.add, color: Colors.white, size: 15),
              ),
            ),
          ),
        ],
      ),
      title: const Text('My status'),
      subtitle: const Text('Tap to add status update'),
      onTap: () async {
        XFile? pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          _navigateToEditStory(context, pickedFile, userInfo);
        }
      },
    );
  }

  void _navigateToEditStory(
      BuildContext context, XFile pickedFile, UserModel userInfo) {
    final navigator = Navigator.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => EditStory(
            imageFiles: [File(pickedFile.path)],
            onImagesSent: (imagesWithCaptions) async {
              final statusCubit = context.read<StatusCubit>();
              for (var item in imagesWithCaptions) {
                final statusesId =
                    FirebaseFirestore.instance.collection('statuses').doc().id;

                await statusCubit.addStatus(
                  Status(
                    statusId: statusesId,
                    userId: userInfo.id,
                    imageUrls: const [],
                    timestamp: DateTime.now(),
                    isText: false,
                    text: item['caption'],
                  ),
                  [item['image'].path],
                );
              }
              statusCubit.fetchStatuses();
            },
          ),
        ),
      );
    });
  }
}
