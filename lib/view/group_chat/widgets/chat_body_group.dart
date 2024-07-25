import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  final String senderName;
  final String senderId;

  const ChatBodyGroup({
    Key? key,
    required this.groupId,
    required this.memberIds,
    required this.groupName,
    required this.groupImageUrl,
    required this.senderName,
    required this.senderId,
  }) : super(key: key);

  @override
  _ChatBodyGroupState createState() => _ChatBodyGroupState();
}

class _ChatBodyGroupState extends State<ChatBodyGroup> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isEmojiVisible = false;

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
          senderId: widget.senderId,
          senderName: widget.senderName,
          imageFile: imageFile,
          caption: caption,
          groupId: widget.groupId,
        );
  }

  void _sendTextMessage() {
    if (_textMessageController.text.isNotEmpty) {
      context.read<GroupChatCubit>().sendGroupTextMessage(
            senderId: widget.senderId,
            senderName: widget.senderName,
            groupId: widget.groupId,
            message: _textMessageController.text,
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
                      return ChatGroupMessageList(
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              ChatGroupTextField(
                groupId: widget.groupId,
                memberIds: widget.memberIds,
                textMessageController: _textMessageController,
                senderName: widget.senderName,
                sendTextMessage: _sendTextMessage,
                addImageMessage: _addImageMessage,
                focusNode: _focusNode,
                isEmojiVisible: _isEmojiVisible,
                toggleEmojiPicker: _toggleEmojiPicker,
                senderId: widget.senderId,
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
