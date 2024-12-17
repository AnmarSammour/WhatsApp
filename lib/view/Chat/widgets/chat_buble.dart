import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp/enum/message_enum.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/view/Chat/widgets/chat_bubble_painter.dart';
import 'package:whatsapp/view/Chat/widgets/full_screen_image.dart';
import 'package:whatsapp/view/Chat/widgets/full_screen_video.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  final MessageModel message;

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    if (widget.message.messageType == MessageType.video) {
      _videoPlayerController =
          VideoPlayerController.network(widget.message.message)
            ..initialize().then((_) {
              setState(() {});
            });
    }

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
    _videoPlayerController?.dispose();
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxMessageWidth),
              child: CustomPaint(
                painter: ChatBubblePainter(isFromFriend: false),
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
                    if (widget.message.messageType == MessageType.file) {}
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
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
                                  const Text('Error loading image'),
                            ),
                          ),
                        if (widget.message.messageType == MessageType.image &&
                            widget.message.message.split('\n').length > 1)
                          Text(
                            widget.message.message
                                .split('\n')
                                .sublist(1)
                                .join('\n'),
                            style: const TextStyle(color: Colors.black),
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
                        if (widget.message.messageType == MessageType.video &&
                            _videoPlayerController != null &&
                            _videoPlayerController!.value.isInitialized)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenVideo(
                                    videoUrl: widget.message.message
                                        .split('\n')
                                        .first,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController!),
                                ),
                                VideoProgressIndicator(
                                  _videoPlayerController!,
                                  allowScrubbing: true,
                                ),
                                IconButton(
                                  icon: Icon(
                                    _videoPlayerController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _videoPlayerController!.value.isPlaying
                                          ? _videoPlayerController!.pause()
                                          : _videoPlayerController!.play();
                                    });
                                  },
                                ),
                                if (widget.message.message.split('\n').length >
                                    1)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      widget.message.message
                                          .split('\n')
                                          .sublist(1)
                                          .join('\n'),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (widget.message.messageType == MessageType.file)
                          Row(
                            children: [
                              const Icon(Icons.insert_drive_file),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.message.message.split('\n').first,
                                  style: const TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        if (widget.message.messageType != MessageType.image &&
                            widget.message.messageType != MessageType.audio &&
                            widget.message.messageType != MessageType.video &&
                            widget.message.messageType != MessageType.file)
                          Text(
                            widget.message.message,
                            style: const TextStyle(color: Colors.black),
                            textAlign: TextAlign.right,
                          ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('hh:mm a')
                              .format(widget.message.time.toDate()),
                          style: const TextStyle(
                              color: Color(0xff606D75), fontSize: 12),
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
