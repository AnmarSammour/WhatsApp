import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatsapp/enum/message_enum.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/view/Chat/widgets/chat_bubble_painter.dart';
import 'package:whatsapp/view/Chat/widgets/full_screen_image.dart';

class ChatBubbleForFriendGroup extends StatefulWidget {
   final MessageModel message;
  final String senderName;
  final String senderImage;

  const ChatBubbleForFriendGroup(
      {Key? key,
      required this.message,
      required this.senderName,
      required this.senderImage})
      : super(key: key);

 
  @override
  _ChatBubbleForFriendGroupState createState() =>
      _ChatBubbleForFriendGroupState();
}

class _ChatBubbleForFriendGroupState extends State<ChatBubbleForFriendGroup> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.message.message));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxMessageWidth = screenWidth * 0.75;

    // Function to generate a unique color based on the sender's name
    Color getColorFromName(String name) {
      final colorList = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.orange,
        Colors.purple,
        Colors.brown,
      ];
      return colorList[name.hashCode % colorList.length];
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: widget.senderImage.isEmpty
                  ? getColorFromName(widget.senderName)
                  : Colors.transparent,
              backgroundImage: widget.senderImage.isNotEmpty
                  ? NetworkImage(widget.senderImage)
                  : null,
              child: widget.senderImage.isEmpty
                  ? Text(
                      widget.senderName[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxMessageWidth),
              child: CustomPaint(
                painter: ChatBubblePainter(isFromFriend: true),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.senderName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: getColorFromName(widget.senderName),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          if (widget.message.messageType == MessageType.image) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImage(
                                  imageUrl:
                                      widget.message.message.split('\n').first,
                                ),
                              ),
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.message.messageType == MessageType.image)
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 400,
                                  maxWidth:
                                      maxMessageWidth > 0 ? maxMessageWidth : 1,
                                ),
                                child: Image.network(
                                  widget.message.message.split('\n').first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('Error loading image'),
                                ),
                              ),
                            if (widget.message.messageType ==
                                    MessageType.image &&
                                widget.message.message.split('\n').length > 1)
                              Text(
                                widget.message.message
                                    .split('\n')
                                    .sublist(1)
                                    .join('\n'),
                                style: const TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                            if (widget.message.messageType == MessageType.audio)
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: _position.inSeconds.toDouble(),
                                      max: _duration.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        _audioPlayer.seek(
                                            Duration(seconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            if (widget.message.messageType !=
                                    MessageType.image &&
                                widget.message.messageType != MessageType.audio)
                              Text(
                                widget.message.message,
                                style: const TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('hh:mm a')
                            .format(widget.message.time.toDate()),
                        style: const TextStyle(
                          color: Color(0xff606D75),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
