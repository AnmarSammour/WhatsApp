import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_chat/new_group.dart';
import 'package:whatsapp/view/settings/settings_view.dart';

class CustomPopupMenuButton extends StatefulWidget {
  final UserModel currentUser;

  const CustomPopupMenuButton({super.key, required this.currentUser});

  @override
  _CustomPopupMenuButtonState createState() => _CustomPopupMenuButtonState();
}

class _CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  final GlobalKey _menuKey = GlobalKey();

  void _showPopupMenu() {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy + renderBox.size.height, position.dx, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'New group',
          child: Text('New group', style: TextStyle(color: Colors.black)),
        ),
        const PopupMenuItem<String>(
          value: 'New broadcast',
          child: Text('New broadcast', style: TextStyle(color: Colors.black)),
        ),
        const PopupMenuItem<String>(
          value: 'Linked devices',
          child: Text('Linked devices', style: TextStyle(color: Colors.black)),
        ),
        const PopupMenuItem<String>(
          value: 'Starred messages',
          child:
              Text('Starred messages', style: TextStyle(color: Colors.black)),
        ),
        const PopupMenuItem<String>(
          value: 'Settings',
          child: Text('Settings', style: TextStyle(color: Colors.black)),
        ),
      ],
      elevation: 10,
      color: const Color(0xffEEF0F1),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
    ).then((value) {
      if (value == 'New group') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewGroup(userInfo: widget.currentUser)),
        );
      } else if (value == 'Settings') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: _menuKey,
      icon: const Icon(Icons.more_vert, color: Color(0xffEEF0F1)),
      onPressed: _showPopupMenu,
    );
  }
}
