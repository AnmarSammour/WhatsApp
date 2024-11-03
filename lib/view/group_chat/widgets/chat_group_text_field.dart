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
  final Function() sendTextMessage;
  final Function(File mediaFile, String caption) addMediaMessage;
  final String senderId;
  final FocusNode focusNode;
  final bool isEmojiVisible;
  final Function() toggleEmojiPicker;

  const ChatGroupTextField({
    Key? key,
    required this.groupId,
    required this.memberIds,
    required this.textMessageController,
    required this.sendTextMessage,
    required this.addMediaMessage,
    required this.focusNode,
    required this.senderId,
    required this.isEmojiVisible,
    required this.toggleEmojiPicker,
  }) : super(key: key);

  @override
  _ChatGroupTextFieldState createState() => _ChatGroupTextFieldState();
}

class _ChatGroupTextFieldState extends State<ChatGroupTextField> {
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
          audioFile: audioFile,
          groupId: widget.groupId,
          membersUid: widget.memberIds,
        );
  }

  Future<void> _handleMediaSelected(
      List<Map<String, dynamic>> selectedMedia) async {
    if (selectedMedia.isNotEmpty) {
      for (var mediaWithCaption in selectedMedia) {
        File mediaFile = mediaWithCaption['file'];
        String caption = mediaWithCaption['caption'] ?? '';

        if (mediaFile.path.endsWith('.mp4')) {
          context.read<GroupChatCubit>().sendGroupVideoMessage(
                videoFile: mediaFile,
                caption: caption,
                groupId: widget.groupId,
                membersUid: widget.memberIds,
              );
        } else {
          context.read<GroupChatCubit>().sendGroupImageMessage(
                imageFile: mediaFile,
                caption: caption,
                groupId: widget.groupId,
                membersUid: widget.memberIds,
              );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFFF7F7F8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(80)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: const Offset(0.0, 0.50),
                            spreadRadius: 1,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              widget.isEmojiVisible
                                  ? Icons.keyboard
                                  : Icons.insert_emoticon,
                            ),
                            color: Colors.grey,
                            onPressed: widget.toggleEmojiPicker,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 60,
                              ),
                              child: Scrollbar(
                                child: TextField(
                                  focusNode: widget.focusNode,
                                  maxLines: null,
                                  style: const TextStyle(fontSize: 14),
                                  controller: widget.textMessageController,
                                  decoration: const InputDecoration(
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
                                      icon: const Icon(Icons.camera_alt),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        List<Map<String, dynamic>>
                                            selectedMediaWithCaptions = [];
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddImage(
                                              onImagesSelected:
                                                  (List<Map<String, dynamic>>
                                                      selectedMedia) {
                                                selectedMediaWithCaptions =
                                                    selectedMedia;
                                              },
                                            ),
                                          ),
                                        );
                                        await _handleMediaSelected(
                                            selectedMediaWithCaptions);
                                      },
                                    )
                                  : const Text(""),
                            ],
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: widget.textMessageController.text.isEmpty
                        ? null
                        : widget.sendTextMessage,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        color: Color(0xFF02B099),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: widget.textMessageController.text.isEmpty
                          ? AudioRecorder(onAudioRecorded: _handleAudioRecorded)
                          : const Icon(Icons.send, color: Colors.white),
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
          SizedBox(
            height: 300.0,
            child: AddAttachFile(
              onImagesSelected: (List<Map<String, dynamic>> selectedMedia) {},
            ),
          ),
      ],
    );
  }
}
