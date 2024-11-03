import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/view/user_info/widgets/hint_text.dart';
import 'package:whatsapp/view/user_info/widgets/user_info_header.dart';
import 'user_image_picker.dart';
import 'user_name_field.dart';
import 'save_button.dart';

class UserInfoViewBody extends StatefulWidget {
  const UserInfoViewBody({Key? key}) : super(key: key);

  @override
  _UserInfoViewBodyState createState() => _UserInfoViewBodyState();
}

class _UserInfoViewBodyState extends State<UserInfoViewBody> {
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  const UserInfoHeader(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  const HintText(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  UserImagePicker(
                    onImagePicked: (pickedImage) {
                      setState(() {
                        image = pickedImage;
                      });
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  UserNameField(controller: nameController),
                ],
              ),
            ),
            SaveButton(
              formKey: _formKey,
              nameController: nameController,
              image: image,
            ),
          ],
        ),
      ),
    );
  }
}
