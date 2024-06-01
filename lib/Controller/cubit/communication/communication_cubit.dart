import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/controller/cubit/communication/communication_state.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/enum/message_enum.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final FirebaseFirestore firestore;

  CommunicationCubit({required this.firestore}) : super(CommunicationInitial());

  Future<void> sendTextMessage({
    required String senderName,
    required String senderId,
    required String recipientId,
    required String recipientName,
    required String message,
    required String recipientPhoneNumber,
    required String senderPhoneNumber,
  }) async {
    try {
      final channelId =
          await _getOneToOneSingleUserChannelId(senderId, recipientId);
      await _sendTextMessageToRepository(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          recipientName: recipientName,
          recipientUID: recipientId,
          messageType: MessageType.text,
          message: message,
          messageId: "",
          time: Timestamp.now(),
        ),
        channelId,
      );
      await _addToMyChat(
        ChatModel(
          time: Timestamp.now(),
          senderName: senderName,
          senderUID: senderId,
          senderPhoneNumber: senderPhoneNumber,
          recipientName: recipientName,
          recipientUID: recipientId,
          recipientPhoneNumber: recipientPhoneNumber,
          recentTextMessage: message,
          imageUrl: "",
          isRead: true,
          isArchived: false,
          channelId: channelId,
        ),
      );
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<void> getMessages(
      {required String senderId, required String recipientId}) async {
    emit(CommunicationLoading());
    try {
      final channelId =
          await _getOneToOneSingleUserChannelId(senderId, recipientId);
      final messagesStreamData = getMessagesFromRepository(channelId);
      messagesStreamData.listen((messages) {
        emit(CommunicationLoaded(messages: messages));
      });
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<String> _getOneToOneSingleUserChannelId(
      String uid, String otherUid) async {
    try {
      final querySnapshot = await firestore
          .collection('chats')
          .where('uids', arrayContains: uid)
          .get();
      for (var doc in querySnapshot.docs) {
        if ((doc.data()['uids'] as List).contains(otherUid)) {
          return doc.id;
        }
      }
      final newChannel = await firestore.collection('chats').add({
        'uids': [uid, otherUid]
      });
      return newChannel.id;
    } catch (e) {
      throw Exception("Failed to get chat channel ID");
    }
  }

  Future<void> _addToMyChat(ChatModel myChatEntity) async {
    try {
      await firestore.collection('my_chats').add(myChatEntity.toDocument());
    } catch (e) {
      throw Exception("Failed to add to my chat");
    }
  }

  Future<void> _sendTextMessageToRepository(
      MessageModel textMessageEntity, String channelId) async {
    try {
      await firestore
          .collection('chats/$channelId/messages')
          .add(textMessageEntity.toDocument());
      await firestore
          .collection('chats')
          .doc(channelId)
          .update({'lastMessage': textMessageEntity.toDocument()});
    } catch (e) {
      throw Exception("Failed to send text message");
    }
  }

  Stream<List<MessageModel>> getMessagesFromRepository(String channelId) {
    return firestore
        .collection('chats/$channelId/messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => MessageModel.fromSnapShot(doc))
            .toList());
  }
}
