import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = _videoPlayerController.value.isPlaying;
        });
      });

    _videoPlayerController.addListener(() {
      setState(() {
        _isPlaying = _videoPlayerController.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  if (!_isPlaying)
                    IconButton(
                      icon: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 50),
                      onPressed: _togglePlayPause,
                    ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: VideoProgressIndicator(
                      _videoPlayerController,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.green,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 20,
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
