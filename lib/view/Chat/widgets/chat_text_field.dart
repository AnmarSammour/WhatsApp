import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/communication/communication_cubit.dart';
import 'package:whatsapp/view/Chat/widgets/add_attach_file.dart';
import 'package:whatsapp/view/Chat/widgets/add_image.dart';
import 'package:whatsapp/view/Chat/widgets/audio_recorder.dart';
import 'package:whatsapp/view/Chat/widgets/emoji_picker.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController textMessageController;
  final FocusNode focusNode;
  final bool isEmojiVisible;
  final Function() toggleEmojiPicker;
  final Function() sendTextMessage;
  final Function(File file, String caption) addMediaMessage;
  final String senderName;
  final String senderUID;
  final String recipientUID;
  final String recipientName;
  final String recipientPhoneNumber;
  final String senderPhoneNumber;

  const ChatTextField({
    Key? key,
    required this.textMessageController,
    required this.focusNode,
    required this.isEmojiVisible,
    required this.toggleEmojiPicker,
    required this.sendTextMessage,
    required this.addMediaMessage,
    required this.senderName,
    required this.senderUID,
    required this.recipientUID,
    required this.recipientName,
    required this.recipientPhoneNumber,
    required this.senderPhoneNumber,
  }) : super(key: key);

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
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
    context.read<CommunicationCubit>().sendAudioMessage(
          senderName: widget.senderName,
          senderId: widget.senderUID,
          recipientId: widget.recipientUID,
          recipientName: widget.recipientName,
          audioFile: audioFile,
          recipientPhoneNumber: widget.recipientPhoneNumber,
          senderPhoneNumber: widget.senderPhoneNumber,
          imageUrl: '',
        );
  }

  Future<void> _handleMediaSelected(
      List<Map<String, dynamic>> selectedMedia) async {
    if (selectedMedia.isNotEmpty) {
      for (var mediaWithCaption in selectedMedia) {
        File mediaFile = mediaWithCaption['file'];
        String caption = mediaWithCaption['caption'] ?? '';

        if (mediaFile.path.endsWith('.mp4')) {
          context.read<CommunicationCubit>().sendVideoMessage(
                senderName: widget.senderName,
                senderId: widget.senderUID,
                recipientId: widget.recipientUID,
                recipientName: widget.recipientName,
                videoFile: mediaFile,
                caption: caption,
                recipientPhoneNumber: widget.recipientPhoneNumber,
                senderPhoneNumber: widget.senderPhoneNumber,
                videoUrl: '',
              );
        } else {
          context.read<CommunicationCubit>().sendImageMessage(
                senderName: widget.senderName,
                senderId: widget.senderUID,
                recipientId: widget.recipientUID,
                recipientName: widget.recipientName,
                imageFile: mediaFile,
                caption: caption,
                recipientPhoneNumber: widget.recipientPhoneNumber,
                senderPhoneNumber: widget.senderPhoneNumber,
                imageUrl: '',
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
