import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/group_info/add_members.dart';
import 'package:whatsapp/view/group_info/change_group_name.dart';

class CustomPopupMenu extends StatefulWidget {
  final UserModel userInfo;
  final String groupId;
  final String initialGroupName;

  const CustomPopupMenu({
    Key? key,
    required this.userInfo,
    required this.groupId,
    required this.initialGroupName,
  }) : super(key: key);

  @override
  _CustomPopupMenuState createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
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
          value: 'Add members',
          child: Text('Add members', style: TextStyle(color: Colors.black)),
        ),
        const PopupMenuItem<String>(
          value: 'Change group name',
          child:
              Text('Change group name', style: TextStyle(color: Colors.black)),
        ),
        const PopupMenuItem<String>(
          value: 'Group permissions',
          child:
              Text('Group permissions', style: TextStyle(color: Colors.black)),
        ),
      ],
      elevation: 10,
      color: const Color(0xffEEF0F1),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
    ).then((value) {
      if (value == 'Add members') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddMembers(
                    userInfo: widget.userInfo,
                    groupId: widget.groupId,
                  )),
        );
      } else if (value == 'Change group name') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeGroupName(
                    groupId: widget.groupId,
                    initialGroupName: widget.initialGroupName,
                  )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: _menuKey,
      icon: const Icon(Icons.more_vert),
      onPressed: _showPopupMenu,
    );
  }
}
