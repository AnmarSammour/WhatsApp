import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/Chat/chat_page_view.dart';
import 'package:whatsapp/view/widgets/user_card.dart';

class CustomSearchDelegate extends SearchDelegate<void> {
  final UserModel currentUser;

  CustomSearchDelegate({required this.currentUser});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(query);
  }

  Widget _buildSearchResults(String query) {
    return FutureBuilder<List<UserModel>>(
      future: _searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        } else {
          List<UserModel> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel user = users[index];
              return UserCard(
                user: user,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatViewPage(
                        senderUID: currentUser.id,
                        recipientUID: user.id,
                        senderName: currentUser.name,
                        recipientName: user.name,
                        recipientPhoneNumber: user.phoneNumber,
                        senderPhoneNumber: currentUser.phoneNumber,
                        imageUrl: user.imageUrl,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Future<List<UserModel>> _searchUsers(String query) async {
    if (query.trim().isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<UserModel> users = [];
      snapshot.docs.forEach((doc) {
        if (doc.exists) {
          users.add(UserModel.fromSnapshot(doc));
        }
      });

      return users;
    } else {
      return [];
    }
  }
}
