import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/group_chat/group_chat_cubit.dart';
import 'package:whatsapp/view/Chat/widgets/add_attach_file.dart';
import 'package:whatsapp/view/Chat/widgets/add_image.dart';
import 'package:whatsapp/view/Chat/widgets/audio_recorder.dart';
import 'package:whatsapp/view/Chat/widgets/emoji_picker.dart';

class ChatGroupTextField extends StatefulWidget {
  final String groupId;
  final List<String> memberIds;
  final TextEditingController textMessageController;
  final String senderName;
  final Function() sendTextMessage;
  final Function(File imageFile, String caption) addImageMessage;
  final String senderId;
  final FocusNode focusNode;
  final bool isEmojiVisible;
  final Function() toggleEmojiPicker;

  const ChatGroupTextField({
    Key? key,
    required this.groupId,
    required this.memberIds,
    required this.textMessageController,
    required this.senderName,
    required this.sendTextMessage,
    required this.addImageMessage,
    required this.focusNode,
    required this.senderId,
    required this.isEmojiVisible,
    required this.toggleEmojiPicker,
  }) : super(key: key);

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatGroupTextField> {
  bool isAttachFileVisible = false;
  bool isEmojiVisible = false;

  void _onEmojiSelected(Emoji emoji) {
    widget.textMessageController.text += emoji.emoji;
  }

  void _toggleAttachFile() {
    setState(() {
      if (isAttachFileVisible) {
        isAttachFileVisible = false;
        FocusScope.of(context).requestFocus(widget.focusNode);
      } else {
        isAttachFileVisible = true;
        isEmojiVisible = false;
        widget.focusNode.unfocus();
      }
    });
  }

  void _handleAudioRecorded(File audioFile) {
    context.read<GroupChatCubit>().sendGroupAudioMessage(
          senderId: widget.senderId,
          senderName: widget.senderName,
          audioFile: audioFile,
          groupId: widget.groupId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFFF7F7F8),
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: Offset(0.0, 0.50),
                            spreadRadius: 1,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              widget.isEmojiVisible
                                  ? Icons.keyboard
                                  : Icons.insert_emoticon,
                            ),
                            color: Colors.grey,
                            onPressed: widget.toggleEmojiPicker,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 60,
                              ),
                              child: Scrollbar(
                                child: TextField(
                                  focusNode: widget.focusNode,
                                  maxLines: null,
                                  style: TextStyle(fontSize: 14),
                                  controller: widget.textMessageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Message",
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isAttachFileVisible = false;
                                      isEmojiVisible = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isAttachFileVisible
                                      ? Icons.keyboard
                                      : Icons.attach_file,
                                ),
                                color: Colors.grey,
                                onPressed: _toggleAttachFile,
                              ),
                              widget.textMessageController.text.isEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        List<Map<String, dynamic>>
                                            selectedImagesWithCaptions = [];
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddImage(
                                              onImagesSelected:
                                                  (List<Map<String, dynamic>>
                                                      selectedImages) {
                                                selectedImagesWithCaptions =
                                                    selectedImages;
                                              },
                                            ),
                                          ),
                                        );
                                        if (selectedImagesWithCaptions
                                            .isNotEmpty) {
                                          for (var imageWithCaption
                                              in selectedImagesWithCaptions) {
                                            File imageFile =
                                                imageWithCaption['image'];
                                            String caption =
                                                imageWithCaption['caption'] ??
                                                    '';
                                            context
                                                .read<GroupChatCubit>()
                                                .sendGroupImageMessage(
                                                  senderId: widget.senderId,
                                                  senderName: widget.senderName,
                                                  imageFile: imageFile,
                                                  caption: caption,
                                                  groupId: widget.groupId,
                                                );
                                          }
                                        }
                                      },
                                    )
                                  : Text(""),
                            ],
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: widget.textMessageController.text.isEmpty
                        ? null
                        : widget.sendTextMessage,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF02B099),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: widget.textMessageController.text.isEmpty
                          ? AudioRecorder(onAudioRecorded: _handleAudioRecorded)
                          : Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
              if (isEmojiVisible)
                EmojiPickerWidget(
                  onEmojiSelected: _onEmojiSelected,
                ),
            ],
          ),
        ),
        if (isAttachFileVisible)
          Container(
            height: 300.0,
            child: AddAttachFile(
              onImagesSelected: (List<Map<String, dynamic>> selectedImages) {},
            ),
          ),
      ],
    );
  }
}
