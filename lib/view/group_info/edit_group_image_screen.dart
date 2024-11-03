import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp/controller/cubit/group_chat/group_chat_cubit.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditGroupImageScreen extends StatefulWidget {
  final File imageFile;
  final GroupChatModel groupChatModel;

  const EditGroupImageScreen(
      {Key? key, required this.imageFile, required this.groupChatModel})
      : super(key: key);

  @override
  _EditGroupImageScreenState createState() => _EditGroupImageScreenState();
}

class _EditGroupImageScreenState extends State<EditGroupImageScreen> {
  File? _editedImageFile;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _editedImageFile = widget.imageFile;
  }

  void _rotateImage() {
    setState(() {
      _rotation += 90.0;
      if (_rotation == 360.0) {
        _rotation = 0.0;
      }
    });
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      await context.read<GroupChatCubit>().updateGroupImage(
            groupId: widget.groupChatModel.groupId,
            imageFile: _editedImageFile!,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group image updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update group image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _editedImageFile != null
                ? Transform.rotate(
                    angle: _rotation * 3.141592653589793 / 180,
                    child: Image.file(_editedImageFile!),
                  )
                : Image.file(widget.imageFile),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_right, color: Colors.white, size: 30),
                  onPressed: _rotateImage,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _saveImage(context),
                    child: const Text('Done', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
