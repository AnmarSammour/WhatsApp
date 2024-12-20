import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/view/group_info/edit_group_image_screen.dart';

class ChangeGroupImage extends StatefulWidget {
  final GroupChatModel groupChatModel;

  const ChangeGroupImage({Key? key, required this.groupChatModel})
      : super(key: key);

  @override
  _ChangeGroupImageState createState() => _ChangeGroupImageState();
}

class _ChangeGroupImageState extends State<ChangeGroupImage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditGroupImageScreen(
            imageFile: File(pickedFile.path),
            groupChatModel: widget.groupChatModel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group icon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.groupChatModel.groupPic),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }
}
