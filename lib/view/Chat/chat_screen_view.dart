import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
       initialIndex:1, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF02B099), 
          title: Text('WhatsApp',
              style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(Icons.camera_alt_outlined,
                  color: Colors.white), 
              onPressed: () {
              },
            ),
            IconButton(
              icon:
                  Icon(Icons.search, color: Colors.white), 
              onPressed: () {
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert,
                  color: Colors.white), 
              onPressed: () {
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.group, color: Colors.white),
              ),
              Tab(
                child: Text(
                  'CHATS',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'STATUS',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'CALLS',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                  child: Text('community',
                      style: TextStyle(color: Colors.black))),
            ),
            ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, color: Colors.grey[700]),
                  ),
                  title: Text('name ${index + 1}',
                      style: TextStyle(color: Colors.black)),
                  subtitle: Text('last message',
                      style: TextStyle(color: Colors.grey)),
                  trailing: Text('time', style: TextStyle(color: Colors.black)),
                );
              },
            ),
            Container(
              color: Colors.green,
              child: Center(
                  child: Text('STATUS',
                      style: TextStyle(color: Colors.white))),
            ),
            Container(
              color: Colors.blue,
              child: Center(
                  child: Text('CALLS',
                      style: TextStyle(color: Colors.white))), 
            ),
          ],
        ),
       
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          backgroundColor: Color(0xFF016B5D), 
          child: Icon(Icons.message, color: Colors.white), 
        ),
      ),
    );
  }
}
