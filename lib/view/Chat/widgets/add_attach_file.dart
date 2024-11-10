import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp/view/Chat/widgets/add_image.dart';
import 'package:whatsapp/view/Chat/widgets/attach_file_option.dart';
import 'package:whatsapp/view/Chat/widgets/gallery_screen.dart';
import 'package:whatsapp/view/Chat/widgets/edit_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAttachFile extends StatelessWidget {
  final Function(List<Map<String, dynamic>>) onImagesSelected;

  const AddAttachFile({super.key, required this.onImagesSelected});

  Future<void> _selectDocument(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null && result.files.isNotEmpty) {
        List<String> selectedFiles =
            result.files.map((file) => file.path ?? '').toList();

        if (selectedFiles.length == 1) {
          Navigator.pop(context);

          File selectedFile = File(selectedFiles.first);

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditFileScreen(
                file: selectedFile,
                filePath: selectedFiles.first,
                onFileSent: (fileWithCaption) {
                  print(
                      'File Sent: ${fileWithCaption['file'].path}, Caption: ${fileWithCaption['caption']}');
                },
              ),
            ),
          );
        } else if (selectedFiles.length > 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm"),
                content: Text(
                    "Send ${selectedFiles.length} documents to the recipient?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Send"),
                  ),
                ],
              );
            },
          );
        }
      }
    } else {
      print("Permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFFF7F7F8),
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 25.0,
        crossAxisSpacing: 8.0,
        shrinkWrap: true,
        children: [
          AttachFileOption(
            icon: Icons.photo_library_outlined,
            color: Colors.purple,
            label: 'Gallery',
            onTap: () async {
              Navigator.pop(context);
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GalleryScreen(),
                ),
              );
            },
          ),
          AttachFileOption(
            icon: Icons.camera_alt_outlined,
            color: Colors.red,
            label: 'Camera',
            onTap: () async {
              Navigator.pop(context);
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddImage(onImagesSelected: onImagesSelected),
                ),
              );
            },
          ),
          AttachFileOption(
            icon: Icons.location_on,
            color: Colors.green,
            label: 'Location',
            onTap: () {},
          ),
          AttachFileOption(
            icon: Icons.contacts,
            color: Colors.blue,
            label: 'Contact',
            onTap: () {},
          ),
          AttachFileOption(
            icon: Icons.insert_drive_file,
            color: Colors.purple,
            label: 'Document',
            onTap: () => _selectDocument(context),
          ),
          AttachFileOption(
            icon: Icons.headset,
            color: Colors.orange,
            label: 'Audio',
            onTap: () {},
          ),
          AttachFileOption(
            icon: Icons.poll,
            color: Colors.yellow,
            label: 'Poll',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
