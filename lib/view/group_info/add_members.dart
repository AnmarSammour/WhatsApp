import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/group_chat/group_chat_cubit.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/widgets/contact_card.dart';
import 'package:whatsapp/view/widgets/custom_fab.dart';

class AddMembers extends StatefulWidget {
  final UserModel userInfo;
  final String groupId;

  const AddMembers({
    Key? key,
    required this.userInfo,
    required this.groupId,
  }) : super(key: key);

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  List<UserModel> selectedContacts = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  List<UserModel> currentGroupMembers = [];

  @override
  void initState() {
    super.initState();
    context.read<GroupChatCubit>().getCurrentGroupMembers(widget.groupId).then((members) {
      setState(() {
        currentGroupMembers = members;
        context.read<GroupChatCubit>().getAllUsers();
      });
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = users.where((user) => !currentGroupMembers.contains(user)).toList();
      } else {
        filteredUsers = users.where((user) {
          final nameLower = user.name.toLowerCase();
          final phoneLower = user.phoneNumber.toLowerCase();
          final queryLower = query.toLowerCase();

          return (nameLower.contains(queryLower) || phoneLower.contains(queryLower)) &&
              !currentGroupMembers.contains(user);
        }).toList();
      }
    });
  }

  Future<void> _addMembersGroup() async {
    List<String> selectedMemberIds = selectedContacts.map((user) => user.id).toList();

    if (selectedMemberIds.isNotEmpty) {
      await context.read<GroupChatCubit>().addMembersToGroup(
        groupId: widget.groupId,
        newMemberIds: selectedMemberIds,
      );
      Navigator.pop(context);
    }
  }

  void _removeContact(UserModel user) {
    setState(() {
      selectedContacts.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search name or number...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                onChanged: (query) => _filterUsers(query),
              )
            : const Text("Add members"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredUsers = users.where((user) => !currentGroupMembers.contains(user)).toList();
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<GroupChatCubit, GroupChatState>(
        builder: (context, state) {
          if (state is GroupChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GroupChatUsersLoaded) {
            users = state.users;
            filteredUsers = state.users.where((user) => !currentGroupMembers.contains(user)).toList();

            return Column(
              children: [
                if (selectedContacts.isNotEmpty)
                  Container(
                    height: 90,
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedContacts.length,
                      itemBuilder: (context, index) {
                        UserModel user = selectedContacts[index];
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: user.imageUrl.isNotEmpty
                                        ? NetworkImage(user.imageUrl)
                                        : null,
                                    child: user.imageUrl.isEmpty
                                        ? const Icon(Icons.person,
                                            size: 30, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeContact(user),
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.close,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      UserModel user = filteredUsers[index];
                      bool isSelected = selectedContacts.contains(user);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedContacts.remove(user);
                            } else {
                              selectedContacts.add(user);
                            }
                          });
                        },
                        child: Container(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                          child: ContactCard(
                            user: user,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedContacts.remove(user);
                                } else {
                                  selectedContacts.add(user);
                                }
                              });
                            },
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is GroupChatError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: CustomFAB(
        onPressed: _addMembersGroup,
        icon: Icons.check,
        heroTag: 'addmembers',
      ),
    );
  }
}
