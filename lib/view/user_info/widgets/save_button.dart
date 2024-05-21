import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState?.validate() ?? false) {
          String name = nameController.text.trim();
          if (name.isNotEmpty) {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              UserModel newUser = UserModel(
                name: name,
                imageUrl: '',
                id: user.uid,
                phoneNumber: '',
                active: true,
                lastSeen: DateTime.now().millisecondsSinceEpoch,
              );
              String? imageUrl;
              if (image != null) {
                imageUrl = await uploadImageToFirestore(image!);
              }

              await addUserToFirestore(newUser, imageUrl);

              BlocProvider.of<UserCubit>(context).updateUser(newUser, image);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data saved successfully')),
              );
              Navigator.of(context).pushNamed('/chat');
            } else {
              print('User is not signed in.');
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF02B099),
      ),
      child: Text('Save'),
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

  Future<void> addUserToFirestore(UserModel user, String? imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).set({
        'name': user.name,
        'imageUrl': imageUrl ?? '',
        'phoneNumber': user.phoneNumber,
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
      rethrow;
    }
  }
}
