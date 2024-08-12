import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/group_chat/group_chat_cubit.dart';
import 'package:whatsapp/view/group_chat/widgets/chat_app_bar_group.dart';
import 'package:whatsapp/view/group_chat/widgets/chat_group_message_list.dart';
import 'package:whatsapp/view/group_chat/widgets/chat_group_text_field.dart';

class ChatBodyGroup extends StatefulWidget {
  final String groupId;
  final List<String> memberIds;
  final String groupName;
  final String groupImageUrl;

  const ChatBodyGroup({
    Key? key,
    required this.groupId,
    required this.memberIds,
    required this.groupName,
    required this.groupImageUrl,
  }) : super(key: key);

  @override
  _ChatBodyGroupState createState() => _ChatBodyGroupState();
}

class _ChatBodyGroupState extends State<ChatBodyGroup> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isEmojiVisible = false;

  late Future<String> _senderNameFuture;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GroupChatCubit>(context)
        .getGroupMessages(groupId: widget.groupId);
    _textMessageController.addListener(() {
      setState(() {});
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isEmojiVisible = false;
        });
      }
    });

    final senderId = FirebaseAuth.instance.currentUser!.uid;
    _senderNameFuture =
        BlocProvider.of<GroupChatCubit>(context).getSenderName(senderId);
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEmojiPicker() {
    if (_isEmojiVisible) {
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      _focusNode.unfocus();
    }
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }

  void _onEmojiSelected(Emoji emoji) {
    _textMessageController.text += emoji.emoji;
  }

  void _addImageMessage(File imageFile, String caption) {
    context.read<GroupChatCubit>().sendGroupImageMessage(
          imageFile: imageFile,
          caption: caption,
          groupId: widget.groupId,
          membersUid: widget.memberIds,
        );
  }

  void _sendTextMessage() {
    if (_textMessageController.text.isNotEmpty) {
      context.read<GroupChatCubit>().sendGroupTextMessage(
            groupId: widget.groupId,
            message: _textMessageController.text,
            membersUid: widget.memberIds,
          );
      _textMessageController.clear();
      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBarGroup(
        groupName: widget.groupName,
        groupImageUrl: widget.groupImageUrl,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              "assets/img/defaultwallpaper.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: BlocBuilder<GroupChatCubit, GroupChatState>(
                  builder: (_, groupChatState) {
                    if (groupChatState is GroupChatLoaded) {
                      return FutureBuilder<String>(
                        future: _senderNameFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            final senderName = snapshot.data!;
                            final senderImage = snapshot.data!;
                            return ChatGroupMessageList(
                              messages: groupChatState.messages,
                              senderId: FirebaseAuth.instance.currentUser!.uid,
                              imageUrl: senderImage,
                              senderName: senderName,
                            );
                          } else {
                            return Center(
                              child: Text('No data available'),
                            );
                          }
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              FutureBuilder<String>(
                future: _senderNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return ChatGroupTextField(
                      groupId: widget.groupId,
                      memberIds: widget.memberIds,
                      textMessageController: _textMessageController,
                      sendTextMessage: _sendTextMessage,
                      addImageMessage: _addImageMessage,
                      focusNode: _focusNode,
                      isEmojiVisible: _isEmojiVisible,
                      toggleEmojiPicker: _toggleEmojiPicker,
                      senderId: FirebaseAuth.instance.currentUser!.uid,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              _isEmojiVisible
                  ? SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          _onEmojiSelected(emoji);
                        },
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 32.0,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
