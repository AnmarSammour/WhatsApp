import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder extends StatefulWidget {
  final Function(File audioFile) onAudioRecorded;

  const AudioRecorder({Key? key, required this.onAudioRecorded}) : super(key: key);

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _audioRecorder!.openRecorder();
    await Permission.microphone.request();
  }

  @override
  void dispose() {
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    super.dispose();
  }

  void _handleAudioRecording() async {
    if (_isRecording) {
      final filePath = await _audioRecorder!.stopRecorder();
      setState(() {
        _isRecording = false;
        _audioFilePath = filePath;
      });
      if (_audioFilePath != null) {
        widget.onAudioRecorded(File(_audioFilePath!));
      }
    } else {
      await _audioRecorder!.startRecorder(toFile: 'audio.aac');
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
      onPressed: _handleAudioRecording,
    );
  }
}
