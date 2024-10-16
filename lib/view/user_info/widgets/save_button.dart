import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp/controller/cubit/user/user_cubit.dart';
import 'package:whatsapp/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final File? image;

  const SaveButton({
    required this.formKey,
    required this.nameController,
    this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void submitProfileInfo() {
      if (nameController.text.isNotEmpty) {
        BlocProvider.of<PhoneAuthCubit>(context)
            .submitProfileInfo(profileUrl: "", name: nameController.text);
      }
    }

    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState?.validate() ?? false) {
          String name = nameController.text.trim();
          if (name.isNotEmpty) {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              String? imageUrl;
              if (image != null) {
                imageUrl = await uploadImageToFirestore(image!);
              }

              UserModel newUser = UserModel(
                name: name,
                imageUrl: imageUrl ?? '',
                id: user.uid,
                phoneNumber: user.phoneNumber ?? '',
                active: true,
                lastSeen: DateTime.now(),
                status: 'Hey there! I am Using WhatsApp Clone.',
              );

              await addUserToFirestore(newUser);

              BlocProvider.of<UserCubit>(context).updateUser(newUser, image);

              Navigator.of(context).pushNamed('/home');
            } else {
              print('User is not signed in.');
            }
          }
        }
        submitProfileInfo();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF02B099),
      ),
      child: const Text('Save'),
    );
  }

  Future<String> uploadImageToFirestore(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('user_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firestore: $e');
      rethrow;
    }
  }

  Future<void> addUserToFirestore(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toDocument());
    } catch (e) {
      print('Error adding user to Firestore: $e');
      rethrow;
    }
  }
}
