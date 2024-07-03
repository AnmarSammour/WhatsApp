import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatsapp/enum/message_enum.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/view/Chat/widgets/chat_bubble_painter.dart';
import 'package:whatsapp/view/Chat/widgets/full_screen_image.dart';

class ChatBubbleForFriend extends StatefulWidget {
  const ChatBubbleForFriend({Key? key, required this.message})
      : super(key: key);

  final MessageModel message;

  @override
  _ChatBubbleForFriendState createState() => _ChatBubbleForFriendState();
}

class _ChatBubbleForFriendState extends State<ChatBubbleForFriend> {
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

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxMessageWidth),
              child: CustomPaint(
                painter: ChatBubblePainter(isFromFriend: true),
                child: GestureDetector(
                  onTap: () {
                    if (widget.message.messageType == MessageType.image) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imageUrl: widget.message.message.split('\n').first,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                  Text('Error loading image'),
                            ),
                          ),
                        if (widget.message.messageType == MessageType.image &&
                            widget.message.message.split('\n').length > 1)
                          Text(
                            widget.message.message
                                .split('\n')
                                .sublist(1)
                                .join('\n'),
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.right,
                          ),
                        if (widget.message.messageType == MessageType.audio)
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                                onPressed: _togglePlayPause,
                              ),
                              Expanded(
                                child: Slider(
                                  value: _position.inSeconds.toDouble(),
                                  max: _duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    _audioPlayer
                                        .seek(Duration(seconds: value.toInt()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (widget.message.messageType != MessageType.image &&
                            widget.message.messageType != MessageType.audio)
                          Text(
                            widget.message.message,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.right,
                          ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat('hh:mm a')
                              .format(widget.message.time.toDate()),
                          style:
                              TextStyle(color: Color(0xff606D75), fontSize: 12),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
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
