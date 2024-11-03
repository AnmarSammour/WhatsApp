import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/status/status_cubit.dart';
import 'package:whatsapp/model/status.dart';

class AddText extends StatefulWidget {
  final String userId;

  const AddText({Key? key, required this.userId}) : super(key: key);

  @override
  _AddTextState createState() => _AddTextState();
}

class _AddTextState extends State<AddText> {
  final TextEditingController _textController = TextEditingController();
  Color backgroundColor = Colors.purple;

  final List<Color> colors = [
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            child: TextField(
              controller: _textController,
              maxLines: null,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 35.0,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Aa',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontSize: 35.0,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 50,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  color: Colors.white,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.title),
                  color: Colors.white,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.color_lens_outlined),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      backgroundColor = (colors..shuffle()).first;
                    });
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 75,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () async {
                          if (_textController.text.isNotEmpty) {
                            final statusesId = FirebaseFirestore.instance
                                .collection('statuses')
                                .doc()
                                .id;

                            await context.read<StatusCubit>().addStatus(
                              Status(
                                statusId: statusesId,
                                userId: widget.userId,
                                imageUrls: const [],
                                timestamp: DateTime.now(),
                                isText: true,
                                text: _textController.text,
                                backgroundColor: backgroundColor,
                              ),
                              [],
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF02B099),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
