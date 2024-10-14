import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/model/chat_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final FirebaseFirestore firestore;

  ChatCubit({required this.firestore}) : super(ChatInitial());

  Future<void> getChat({required String uid}) async {
    try {
      final myChatStreamData = firestore
          .collection('my_chats')
          .where('senderUID', isEqualTo: uid)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => ChatModel.fromSnapshot(doc))
              .toList());
      myChatStreamData.listen((myChatData) {
        emit(ChatLoaded(chatModel: myChatData));
      });
    } on SocketException catch (_) {
      emit(ChatError(message: 'SocketException occurred'));
    } catch (_) {
      emit(ChatError(message: 'An error occurred'));
    }
  }
}
