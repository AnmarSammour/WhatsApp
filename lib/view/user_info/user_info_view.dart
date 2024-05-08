import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/controller/cubit/user/user_cubit.dart';
import 'package:whatsapp/model/user.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final nameController = TextEditingController();
  File? image;
  final ImagePicker picker = ImagePicker();
  late UserCubit userCubit;

  @override
  void initState() {
    super.initState();
    userCubit = BlocProvider.of<UserCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User information'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: selectImage,
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.black,
                backgroundImage: image != null ? FileImage(image!) : null,
                child: image == null
                    ? Icon(
                        Icons.person,
                        size: 75,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: storeUserData,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF02B099), 
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void selectImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> storeUserData() async {
    final String name = nameController.text.trim();
    if (name.isNotEmpty && image != null) {
      // upload image in Firebase Storage
      final String filePath = 'user_images/${image!.path.split('/').last}';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(filePath);
      final UploadTask uploadTask = storageReference.putFile(image!);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // save data in Firestore
      final DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc();
      await userDocRef.set({
        'name': name,
        'imageUrl': imageUrl,
      });
      userCubit.updateUser(UserModel(name: name, imageUrl: imageUrl) as User);
      Navigator.pushReplacementNamed(context, '/chat');
    }
  }
}
