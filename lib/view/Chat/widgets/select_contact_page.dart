import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/Chat/chat_page_view.dart';
import 'package:whatsapp/view/group_chat/new_group.dart';
import 'package:whatsapp/view/home/widgets/Custom_search_delegate.dart';
import 'package:whatsapp/view/widgets/user_card.dart';

class SelectContactPage extends StatefulWidget {
  final UserModel userInfo;

  const SelectContactPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  _SelectContactPageState createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  List<UserModel> users = [];
  @override
  void initState() {
    _getAllUsers();
    super.initState();
  }

  void _getAllUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<UserModel> loadedUsers = [];
      snapshot.docs.forEach((doc) {
        if (doc.exists) {
          loadedUsers.add(UserModel.fromSnapshot(doc));
        }
      });

      setState(() {
        users = loadedUsers;
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              showSearchPage(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            _newGroupButtonWidget(),
            SizedBox(height: 10),
            _newContactButtonWidget(),
            SizedBox(height: 10),
            _listContact(),
          ],
        ),
      ),
    );
  }

  Widget _newGroupButtonWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewGroup(userInfo: widget.userInfo)),
        );
      },
      child: Container(
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Color(0xFF02B099),
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Icon(
                Icons.people,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 15),
            Text(
              "New Group",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newContactButtonWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Color(0xFF02B099),
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Text(
                "New contact",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            Icons.qr_code,
            color: Color(0xFF02B099),
          )
        ],
      ),
    );
  }

  Widget _listContact() {
    return Expanded(
      child: ListView.builder(
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
                    recipientName: user.name,
                    recipientPhoneNumber: user.phoneNumber,
                    recipientUID: user.id,
                    senderName: widget.userInfo.name,
                    senderUID: widget.userInfo.id,
                    senderPhoneNumber: widget.userInfo.phoneNumber,
                    imageUrl: user.imageUrl,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showSearchPage(BuildContext context) {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(currentUser: widget.userInfo),
    );
  }
}
