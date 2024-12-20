import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/user/user_cubit.dart';
import 'package:whatsapp/controller/cubit/user/user_state.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/settings/widgets/meta_option.dart';
import 'package:whatsapp/view/settings/widgets/profile_settings.dart';
import 'package:whatsapp/view/settings/widgets/settings_option.dart';
import 'package:whatsapp/view/settings/widgets/search_bar.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> settingsOptions = [
    {
      'icon': Icons.key,
      'title': 'Account',
      'subtitle': 'Security notifications, change number'
    },
    {
      'icon': Icons.lock,
      'title': 'Privacy',
      'subtitle': 'Block contacts, disappearing messages'
    },
    {
      'icon': Icons.person,
      'title': 'Avatar',
      'subtitle': 'Create, edit, profile photo'
    },
    {
      'icon': Icons.favorite,
      'title': 'Favorites',
      'subtitle': 'Add, reorder, remove'
    },
    {
      'icon': Icons.chat,
      'title': 'Chats',
      'subtitle': 'Theme, wallpapers, chat history'
    },
    {
      'icon': Icons.notifications,
      'title': 'Notifications',
      'subtitle': 'Message, group & call tones'
    },
    {
      'icon': Icons.storage,
      'title': 'Storage and data',
      'subtitle': 'Network usage, auto-download'
    },
    {
      'icon': Icons.language,
      'title': 'App language',
      'subtitle': 'English (device\'s language)'
    },
    {
      'icon': Icons.help,
      'title': 'Help',
      'subtitle': 'Help center, contact us, privacy policy'
    },
    {'icon': Icons.people, 'title': 'Invite a friend', 'subtitle': ''},
    {'icon': Icons.update, 'title': 'App updates', 'subtitle': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? Searchbar(
                controller: searchController,
                onBack: () {
                  setState(() {
                    isSearching = false;
                    searchController.clear();
                  });
                },
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text('Settings'),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
        ],
        leading: isSearching
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        automaticallyImplyLeading: !isSearching,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            UserModel user = state.user.first;

            return ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.imageUrl)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name),
                          const SizedBox(height: 4),
                          Text(
                            user.status,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(Icons.qr_code,
                              size: 20, color: Color(0xFF02B099)),
                          SizedBox(width: 8),
                          Icon(Icons.expand_circle_down_outlined,
                              size: 20, color: Color(0xFF02B099)),
                        ],
                      ),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettings(),
                      ),
                    );
                    context.read<UserCubit>().loadUser();
                  },
                ),
                const Divider(),
                ...settingsOptions.where((option) {
                  if (isSearching && searchController.text.isNotEmpty) {
                    return option['title']
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase());
                  }
                  return true;
                }).map((option) {
                  return SettingsOption(
                    icon: option['icon'],
                    title: option['title'],
                    subtitle: option['subtitle'],
                  );
                }).toList(),
                const Divider(),
                const MetaOption(icon: Icons.camera, title: 'Open Instagram'),
                const MetaOption(icon: Icons.facebook, title: 'Open Facebook'),
              ],
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
