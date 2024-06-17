import 'package:flutter/material.dart';
import 'package:whatsapp/view/Chat/widgets/attach_file_option.dart';

class AddAttachFile extends StatelessWidget {
  const AddAttachFile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFFF7F7F8),
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
            onTap: () {},
          ),
          AttachFileOption(
            icon: Icons.camera_alt_outlined,
            color: Colors.red,
            label: 'Camera',
            onTap: () {},
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
            onTap: () {},
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
