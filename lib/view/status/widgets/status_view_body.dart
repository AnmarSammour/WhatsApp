import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller/cubit/status/status_cubit.dart';
import 'package:whatsapp/model/status.dart';
import 'package:whatsapp/model/user.dart';
import 'dart:io';
import 'package:whatsapp/view/status/widgets/add_text.dart';
import 'package:whatsapp/view/status/widgets/edit_story.dart';
import 'package:whatsapp/view/status/widgets/my_status.dart';
import 'package:whatsapp/view/status/widgets/status_list_view.dart';
import 'package:whatsapp/view/widgets/custom_fab.dart';

class StatusViewBody extends StatelessWidget {
  final UserModel userInfo;

  const StatusViewBody({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusCubit()..fetchStatuses(),
      child: Scaffold(
        body: BlocBuilder<StatusCubit, StatusState>(
          builder: (context, state) {
            if (state is StatusLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatusError) {
              return Center(child: Text(state.message));
            } else if (state is StatusLoaded) {
              List<Status> statusList = state.statuses;

              Map<String, List<Status>> userStatuses = {};
              for (Status status in statusList) {
                if (!userStatuses.containsKey(status.userId)) {
                  userStatuses[status.userId] = [];
                }
                userStatuses[status.userId]!.add(status);
              }

              return ListView(
                children: <Widget>[
                  MyStatus(userInfo: userInfo),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Recent updates',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...userStatuses.entries.map((entry) {
                    return StatusListView(
                        userId: entry.key, statuses: entry.value);
                  }).toList(),
                ],
              );
            }
            return const Center(child: Text('No statuses available'));
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomFAB(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddText(userId: userInfo.id),
                  ),
                );
              },
              icon: Icons.edit,
              heroTag: 'edit_button_hero',
            ),
            SizedBox(height: 10),
            CustomFAB(
              onPressed: () async {
                XFile? pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  _navigateToEditStory(context, pickedFile, userInfo);
                }
              },
              icon: Icons.camera_alt,
              heroTag: 'camera_button_hero',
            ),
          ],
        ),
      ),
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
                await statusCubit.addStatus(
                  Status(
                    id: '',
                    userId: userInfo.id,
                    imageUrls: [],
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
