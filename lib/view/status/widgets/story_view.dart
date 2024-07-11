import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp/model/status.dart';
import 'package:whatsapp/model/user.dart';

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
  final TextEditingController _textController = TextEditingController();
  bool _isTextEmpty = true;

  @override
  void dispose() {
    _storyController.dispose();
    _textController.dispose();
    super.dispose();
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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.user.imageUrl),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    if (widget.statuses.isNotEmpty) ...[
                      Text(
                        formatTimestamp(widget.statuses.first.timestamp),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Color(0xffEEF0F1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Reply',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() {
                          _isTextEmpty = text.isEmpty;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isTextEmpty ? Icons.mic : Icons.send,
                      color: Colors.grey,
                    ),
                    onPressed: _isTextEmpty
                        ? null
                        : () {
                            _textController.clear();
                            setState(() {
                              _isTextEmpty = true;
                            });
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
}
