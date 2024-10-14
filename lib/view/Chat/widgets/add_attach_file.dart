import 'package:flutter/material.dart';
import 'package:whatsapp/view/Chat/widgets/add_image.dart';
import 'package:whatsapp/view/Chat/widgets/attach_file_option.dart';
import 'package:whatsapp/view/Chat/widgets/gallery_screen.dart';

class AddAttachFile extends StatelessWidget {
  final Function(List<Map<String, dynamic>>) onImagesSelected;

  AddAttachFile({super.key, required this.onImagesSelected});

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
