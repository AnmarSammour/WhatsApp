import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller/cubit/user/user_cubit.dart';
import 'package:whatsapp/controller/cubit/user/user_state.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/settings/widgets/about.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  File? _imageFile;

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      UserCubit userCubit = context.read<UserCubit>();
      if (userCubit.state is UserLoaded) {
        UserModel user = (userCubit.state as UserLoaded).user.first;
        final newUser = UserModel(
          id: user.id,
          name: user.name,
          imageUrl: user.imageUrl,
          active: user.active,
          lastSeen: user.lastSeen,
          phoneNumber: user.phoneNumber,
          status: user.status,
        );
        userCubit.updateUser(newUser, _imageFile);
      }
    }
  }

  void _showEditNameBottomSheet(BuildContext context, UserModel user) {
    TextEditingController nameController =
        TextEditingController(text: user.name);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your name', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              TextField(controller: nameController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final newUser = UserModel(
                        id: user.id,
                        name: nameController.text,
                        imageUrl: user.imageUrl,
                        active: user.active,
                        lastSeen: user.lastSeen,
                        phoneNumber: user.phoneNumber,
                        status: user.status,
                      );
                      context.read<UserCubit>().updateUser(newUser, _imageFile);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF0F1),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xffEEF0F1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              UserModel user = state.user.first;
              return Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile == null
                            ? NetworkImage(user.imageUrl)
                            : FileImage(_imageFile!) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _pickImage(context),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFF02B099),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.person_2_outlined, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Name',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            Text(user.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            const Text(
                                'This is not your username or pin. This name will be visible to your WhatsApp contacts.',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF02B099)),
                        onPressed: () =>
                            _showEditNameBottomSheet(context, user),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('About',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AboutUser()),
                                );
                              },
                              child: Text(user.status,
                                  style: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF02B099)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutUser()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phone',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            Text(user.phoneNumber,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is UserError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}
