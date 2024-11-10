import 'dart:io';
import 'package:flutter/material.dart';

class EditFileScreen extends StatefulWidget {
  final File file;
  final Function(Map<String, dynamic>) onFileSent;

  const EditFileScreen(
      {Key? key,
      required this.file,
      required this.onFileSent,
      required String filePath})
      : super(key: key);

  @override
  _EditFileScreenState createState() => _EditFileScreenState();
}

class _EditFileScreenState extends State<EditFileScreen> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _sendFile() {
    final Map<String, dynamic> fileWithCaption = {
      'file': widget.file,
      'caption': _captionController.text,
      'messageType': 3, // نوع الرسالة المحدد للملفات
    };
    widget.onFileSent(fileWithCaption); // استدعاء دالة الإرسال
    Navigator.pop(context); // الرجوع للصفحة السابقة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit File'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendFile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected File:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.file.path.split('/').last, // اسم الملف
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Add a caption (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
