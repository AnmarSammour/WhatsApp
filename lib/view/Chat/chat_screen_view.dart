import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/controller/cubit/chat/chat_cubit.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/view/Chat/chat_page_view.dart';
import 'package:whatsapp/view/Chat/widgets/chat_items.dart';
import 'package:whatsapp/view/Chat/widgets/select_contact_page.dart';
import 'package:whatsapp/view/widgets/custom_fab.dart';

class ChatView extends StatefulWidget {
  final UserModel userInfo;

  const ChatView({Key? key, required this.userInfo}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).getChat(uid: widget.userInfo.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF7F7F8),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (_, myChatState) {
          if (myChatState is ChatLoaded) {
            if (myChatState.chatModel.isEmpty) {
              return emptyListDisplayMessageWidget();
            } else {
              return chatList(myChatState);
            }
          }
          return emptyListDisplayMessageWidget();
        },
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectContactPage(
                userInfo: widget.userInfo,
              ),
            ),
          );
        },
        icon: Icons.chat,
      ),
    );
  }

  Widget emptyListDisplayMessageWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: const Color(0xFF02B099).withOpacity(.5),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: Icon(
            Icons.message,
            color: Colors.white.withOpacity(.6),
            size: 40,
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Start chat with your friends and family,\n on WhatsApp Clone",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatList(ChatLoaded chatData) {
    return ListView.builder(
      itemCount: chatData.chatModel.length,
      itemBuilder: (_, index) {
        final chat = chatData.chatModel[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatViewPage(
                  senderPhoneNumber: chat.senderPhoneNumber,
                  senderUID: widget.userInfo.id,
                  senderName: chat.senderName,
                  recipientUID: chat.recipientUID,
                  recipientPhoneNumber: chat.recipientPhoneNumber,
                  recipientName: chat.recipientName,
                  imageUrl: chat.imageUrl,
                ),
              ),
            );
          },
          child: ChatItems(
            name: chat.recipientName,
            recentSendMessage: chat.recentTextMessage,
            time: DateFormat('hh:mm a').format(chat.time.toDate()),
            imageUrl: chat.imageUrl,
            phoneNumber: chat.recipientPhoneNumber,
            status: '',
            uid: '',
          ),
        );
      },
    );
  }
}
