import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/contact_info/action_buttons.dart';
import 'package:whatsapp/view/contact_info/group_section.dart';
import 'package:whatsapp/view/contact_info/settings_section.dart';
import 'package:whatsapp/view/contact_info/user_header.dart';
import 'package:whatsapp/view/contact_info/user_status.dart';

class ContactInfoPage extends StatelessWidget {
  final UserModel user;

  const ContactInfoPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  Future<String> _getUserStatus(String phoneNumber) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first.data()['status'] as String? ??
            'No status available';
      } else {
        return 'No status available';
      }
    } catch (e) {
      print('Error fetching user status: $e');
      return 'Error fetching status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          UserHeader(user: user),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 5,
                  ),
                ),
                UserStatus(
                    phoneNumber: user.phoneNumber,
                    getUserStatus: _getUserStatus),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 5,
                  ),
                ),
                SettingsSection(user: user),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 5,
                  ),
                ),
                GroupSection(user: user),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 5,
                  ),
                ),
                ActionButtons(user: user),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
