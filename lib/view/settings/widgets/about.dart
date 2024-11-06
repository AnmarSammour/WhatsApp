import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/user/user_cubit.dart';
import 'package:whatsapp/controller/cubit/user/user_state.dart';
import 'package:whatsapp/model/user.dart';

class AboutUser extends StatelessWidget {
  const AboutUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF0F1),
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xffEEF0F1),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Add action for more_vert icon
            },
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            UserModel user = state.user.first;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Currently set to'),
                      subtitle: Row(
                        children: [
                          Expanded(child: Text(user.status)),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFF02B099)),
                            onPressed: () => _editStatus(context, user),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Select About'),
                    ),
                    ..._statusOptions(context, user),
                  ],
                ),
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _editStatus(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController statusController =
            TextEditingController(text: user.status);
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
              const Text('Add About', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                  suffixIcon:
                      Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                  suffixIconConstraints: BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                ),
              ),
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
                      String newStatus = statusController.text;
                      UserModel updatedUser = UserModel(
                        id: user.id,
                        name: user.name,
                        imageUrl: user.imageUrl,
                        active: user.active,
                        lastSeen: user.lastSeen,
                        phoneNumber: user.phoneNumber,
                        status: newStatus,
                      );
                      BlocProvider.of<UserCubit>(context)
                          .updateUser(updatedUser, null);
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

  List<Widget> _statusOptions(BuildContext context, UserModel user) {
    List<String> statuses = [
      'Available',
      'Busy',
      'At school',
      'At the movies',
      'At work',
      'Battery about to die',
      'Can\'t talk, WhatsApp only',
      'In a meeting',
      'At the gym',
      'Sleeping',
      'Urgent calls only',
    ];
    return statuses.map((status) {
      return ListTile(
        title: Text(status),
        trailing: user.status == status
            ? const Icon(Icons.check, color: Color(0xFF02B099))
            : null,
        onTap: () {
          UserModel updatedUser = UserModel(
            id: user.id,
            name: user.name,
            imageUrl: user.imageUrl,
            active: user.active,
            lastSeen: user.lastSeen,
            phoneNumber: user.phoneNumber,
            status: status,
          );
          BlocProvider.of<UserCubit>(context).updateUser(updatedUser, null);
        },
      );
    }).toList();
  }
}
