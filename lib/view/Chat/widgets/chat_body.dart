import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/communication/communication_cubit.dart';
import 'package:whatsapp/controller/cubit/communication/communication_state.dart';
import 'package:whatsapp/view/Chat/widgets/chat_app_bar.dart';
import 'package:whatsapp/view/Chat/widgets/chat_message_list.dart';
import 'package:whatsapp/view/Chat/widgets/chat_text_field.dart';

class ChatBody extends StatefulWidget {
  final String senderUID;
  final String recipientUID;
  final String senderName;
  final String recipientName;
  final String recipientPhoneNumber;
  final String senderPhoneNumber;
  final String imageUrl;

  const ChatBody({
    Key? key,
    required this.senderUID,
    required this.recipientUID,
    required this.senderName,
    required this.recipientName,
    required this.recipientPhoneNumber,
    required this.senderPhoneNumber,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isEmojiVisible = false;

  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CommunicationCubit>(context).getMessages(
      senderId: widget.senderUID,
      recipientId: widget.recipientUID,
    );
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
    setState(() {
      _messages.add({
        'type': 'image',
        'file': imageFile,
        'caption': caption,
        'senderUID': widget.senderUID,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        recipientName: widget.recipientName,
        imageUrl: widget.imageUrl,
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
                child: BlocBuilder<CommunicationCubit, CommunicationState>(
                  builder: (_, communicationState) {
                    if (communicationState is CommunicationLoaded) {
                      return ChatMessageList(
                        messages: communicationState.messages,
                        senderUID: widget.senderUID,
                        imageUrl: widget.imageUrl,
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              ChatTextField(
                textMessageController: _textMessageController,
                focusNode: _focusNode,
                isEmojiVisible: _isEmojiVisible,
                toggleEmojiPicker: _toggleEmojiPicker,
                sendTextMessage: _sendTextMessage,
                addImageMessage: _addImageMessage,
                senderUID: widget.senderUID,
                recipientUID: widget.recipientUID,
                senderName: widget.senderName,
                recipientName: widget.recipientName,
                recipientPhoneNumber: widget.recipientPhoneNumber,
                senderPhoneNumber: widget.senderPhoneNumber,
                imageUrl: widget.imageUrl,
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

  void _sendTextMessage() {
    if (_textMessageController.text.isNotEmpty) {
      BlocProvider.of<CommunicationCubit>(context).sendTextMessage(
        recipientId: widget.recipientUID,
        senderId: widget.senderUID,
        recipientPhoneNumber: widget.recipientPhoneNumber,
        recipientName: widget.recipientName,
        senderPhoneNumber: widget.senderPhoneNumber,
        senderName: widget.senderName,
        message: _textMessageController.text,
        imageUrl: widget.imageUrl,
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
}
