import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/status/status_cubit.dart';
import 'package:whatsapp/model/status.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/model/viewer.dart';

class StoryViewScreen extends StatefulWidget {
  final List<Status> statuses;
  final UserModel user;

  StoryViewScreen({required this.statuses, required this.user, Key? key})
      : super(key: key);

  @override
  _StoryViewScreenState createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  final StoryController _storyController = StoryController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  int currentIndex = 0;
  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _storyController.dispose();
    currentIndexNotifier.dispose();

    super.dispose();
  }

  void _showViewers(String statusId) async {
    _storyController.pause();

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('statuses')
          .doc(statusId)
          .get();

      if (snapshot.exists) {
        List<dynamic> viewersData = snapshot.get('viewers') ?? [];
        List<Viewer> viewers =
            viewersData.map((viewer) => Viewer.fromMap(viewer)).toList();

        double height = (viewers.length * 70).toDouble() + 100;
        if (height > MediaQuery.of(context).size.height * 0.6) {
          height = MediaQuery.of(context).size.height * 0.6;
        }

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.green,
                    child: Row(
                      children: [
                        Text(
                          'Viewed by ${viewers.length}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Spacer(),
                        Icon(Icons.facebook, color: Colors.white),
                        SizedBox(width: 10),
                        Icon(Icons.more_vert, color: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewers.length,
                      itemBuilder: (context, index) {
                        final viewer = viewers[index];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(viewer.viewerId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child: CircularProgressIndicator(),
                                  backgroundColor: Colors.blue,
                                ),
                                title: Text('Loading...'),
                              );
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                  backgroundColor: Colors.grey,
                                ),
                                title: Text('Unknown User'),
                              );
                            }
                            final user = UserModel.fromSnapshot(snapshot.data!);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: user.imageUrl.isNotEmpty
                                    ? NetworkImage(user.imageUrl)
                                    : const Icon(
                                        Icons.person,
                                        size: 40.0,
                                        color: Colors.grey,
                                      ) as ImageProvider,
                              ),
                              title: Text(user.name),
                              subtitle: Text(
                                '${DateFormat('hh:mm a').format(viewer.viewedAt)}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ).whenComplete(() {
          _storyController.play();
        });
      }
    } catch (e) {
      print('Error fetching viewers: $e');
    }
  }

  void _deleteStory(String statusId) async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleting status update...')),
    );

    final cubit = context.read<StatusCubit>();

    bool success = await cubit.deleteStatus(statusId);
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleting status update...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete status update')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String statusId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Status Update?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteStory(statusId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String formatTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    if (timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day) {
      return 'Today, ${DateFormat.jm().format(timestamp)}';
    } else if (timestamp.year == yesterday.year &&
        timestamp.month == yesterday.month &&
        timestamp.day == yesterday.day) {
      return 'Yesterday, ${DateFormat.jm().format(timestamp)}';
    } else {
      return DateFormat.yMMMd().add_jm().format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.statuses.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    List<StoryItem> storyItems = widget.statuses.map((status) {
      if (status.isText) {
        return StoryItem.text(
          title: status.text,
          backgroundColor: status.backgroundColor ?? Colors.black,
          textStyle: TextStyle(fontSize: 30, color: Colors.white),
        );
      } else {
        return StoryItem.pageImage(
          url: status.imageUrls.first,
          controller: _storyController,
          caption: Text(status.text),
        );
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StoryView(
            storyItems: storyItems,
            controller: _storyController,
            onComplete: () {
              Navigator.pop(context);
            },
            onStoryShow: (storyItem, position) {
              currentIndexNotifier.value = position;

              final status = widget.statuses[position];
              final cubit = context.read<StatusCubit>();
              if (status.userId != currentUser!.uid) {
                cubit.logViewer(status.statusId, currentUser!.uid);
              }
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            inline: false,
          ),
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatTimestamp(widget.statuses.first.timestamp),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 16),
                    ),
                  ],
                ),
                Spacer(),
                widget.statuses.first.userId == currentUser!.uid
                    ? GestureDetector(
                        onTap: () {
                          _storyController.pause();
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(100, 80, 0, 0),
                            items: [
                              PopupMenuItem<String>(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ).then((value) {
                            if (value == 'Delete') {
                              String currentStatusId = widget
                                  .statuses[currentIndexNotifier.value]
                                  .statusId;
                              _showDeleteConfirmationDialog(currentStatusId);
                            } else {
                              _storyController.play();
                            }
                          });
                        },
                        child: Icon(Icons.more_vert, color: Colors.white),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  _showViewers(
                      widget.statuses[currentIndexNotifier.value].statusId);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.remove_red_eye, color: Colors.white, size: 20),
                      SizedBox(width: 5),
                      ValueListenableBuilder<int>(
                        valueListenable: currentIndexNotifier,
                        builder: (context, currentIndex, _) {
                          return Text(
                            '${widget.statuses[currentIndex].viewers.length} views',
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
