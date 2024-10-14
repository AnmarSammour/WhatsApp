import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp/controller/cubit/communication/communication_state.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/enum/message_enum.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  CommunicationCubit({required this.firestore, required this.storage})
      : super(CommunicationInitial());

  Future<void> sendTextMessage({
    required String senderName,
    required String senderId,
    required String recipientId,
    required String recipientName,
    required String message,
    required String recipientPhoneNumber,
    required String senderPhoneNumber,
    required String imageUrl,
  }) async {
    try {
      final channelId =
          await _getOneToOneSingleUserChatChannel(senderId, recipientId);
      await _sendMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          recipientName: recipientName,
          recipientUID: recipientId,
          messageType: MessageType.text,
          message: message,
          time: Timestamp.now(),
          membersUid: [],
          senderImage: '',
        ),
        channelId,
      );
      await _addToMyChat(ChatModel(
        time: Timestamp.now(),
        senderName: senderName,
        senderUID: senderId,
        senderPhoneNumber: senderPhoneNumber,
        recipientName: recipientName,
        recipientUID: recipientId,
        recipientPhoneNumber: recipientPhoneNumber,
        recentTextMessage: message,
        imageUrl: imageUrl,
        isRead: true,
        isArchived: false,
        channelId: channelId,
      ));
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<void> sendImageMessage({
    required String senderName,
    required String senderId,
    required String recipientId,
    required String recipientName,
    required File imageFile,
    required String recipientPhoneNumber,
    required String senderPhoneNumber,
    required String imageUrl,
    required String caption,
  }) async {
    try {
      final channelId =
          await _getOneToOneSingleUserChatChannel(senderId, recipientId);
      final imageUrl = await _uploadImage(channelId, imageFile);
      final message = imageUrl + (caption.isNotEmpty ? '\n$caption' : '');
      await _sendMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          recipientName: recipientName,
          recipientUID: recipientId,
          messageType: MessageType.image,
          message: message,
          time: Timestamp.now(),
          membersUid: [],
          senderImage: '',
        ),
        channelId,
      );
      await _addToMyChat(ChatModel(
        time: Timestamp.now(),
        senderName: senderName,
        senderUID: senderId,
        senderPhoneNumber: senderPhoneNumber,
        recipientName: recipientName,
        recipientUID: recipientId,
        recipientPhoneNumber: recipientPhoneNumber,
        recentTextMessage: "Image",
        imageUrl: imageUrl,
        isRead: true,
        isArchived: false,
        channelId: channelId,
      ));
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<String> _uploadImage(String channelId, File imageFile) async {
    final ref = storage.ref().child(
        'chat_images/$channelId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> getMessages(
      {required String senderId, required String recipientId}) async {
    emit(CommunicationLoading());
    try {
      final channelId =
          await _getOneToOneSingleUserChatChannel(senderId, recipientId);
      final messagesStream = _getMessages(channelId);
      messagesStream.listen((messages) {
        emit(CommunicationLoaded(messages: messages));
      });
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<String> _getOneToOneSingleUserChatChannel(
      String uid, String otherUid) async {
    try {
      final existingChannel = await _getExistingChannel(uid, otherUid);
      if (existingChannel != null) {
        return existingChannel;
      } else {
        final channelId = ChatModel.generateChannelId(uid, otherUid);
        await firestore.collection('chats').doc(channelId).set({
          'uids': [uid, otherUid]
        });
        return channelId;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _getExistingChannel(String uid, String otherUid) async {
    try {
      final querySnapshot = await firestore
          .collection('chats')
          .where('uids', arrayContains: [uid, otherUid]).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _sendMessage(MessageModel message, String channelId) async {
    try {
      await firestore
          .collection('chats')
          .doc(channelId)
          .collection('messages')
          .add(message.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MessageModel>> _getMessages(String channelId) {
    return firestore
        .collection('chats')
        .doc(channelId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => MessageModel.fromSnapShot(doc))
            .toList());
  }

  Future<void> _addToMyChat(ChatModel myChatEntity) async {
    try {
      await firestore
          .collection('myChats')
          .doc(myChatEntity.senderUID)
          .collection('chats')
          .doc(myChatEntity.channelId)
          .set(myChatEntity.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendAudioMessage({
    required String senderName,
    required String senderId,
    required String recipientId,
    required String recipientName,
    required File audioFile,
    required String recipientPhoneNumber,
    required String senderPhoneNumber,
    required String imageUrl,
  }) async {
    try {
      final channelId =
          await _getOneToOneSingleUserChatChannel(senderId, recipientId);
      final audioUrl = await _uploadAudio(channelId, audioFile);
      await _sendMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          recipientName: recipientName,
          recipientUID: recipientId,
          messageType: MessageType.audio,
          message: audioUrl,
          time: Timestamp.now(),
          membersUid: [],
          senderImage: '',
        ),
        channelId,
      );
      await _addToMyChat(ChatModel(
        time: Timestamp.now(),
        senderName: senderName,
        senderUID: senderId,
        senderPhoneNumber: senderPhoneNumber,
        recipientName: recipientName,
        recipientUID: recipientId,
        recipientPhoneNumber: recipientPhoneNumber,
        recentTextMessage: "Audio",
        imageUrl: imageUrl,
        isRead: true,
        isArchived: false,
        channelId: channelId,
      ));
    } catch (e) {
      emit(CommunicationFailure());
    }
  }

  Future<String> _uploadAudio(String channelId, File audioFile) async {
    final ref = storage.ref().child(
        'audio_messages/$channelId/${DateTime.now().millisecondsSinceEpoch}.m4a');
    final uploadTask = ref.putFile(audioFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> sendVideoMessage({
    required String senderName,
    required String senderId,
    required String recipientId,
    required String recipientName,
    required File videoFile,
    required String recipientPhoneNumber,
    required String senderPhoneNumber,
    required String videoUrl,
    required String caption,
  }) async {
    try {
      final channelId =
          await _getOneToOneSingleUserChatChannel(senderId, recipientId);

      final videoUrl = await _uploadVideo(channelId, videoFile);

      final message = videoUrl + (caption.isNotEmpty ? '\n$caption' : '');

      await _sendMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          recipientName: recipientName,
          recipientUID: recipientId,
          messageType: MessageType.video,
          message: message,
          time: Timestamp.now(),
          membersUid: [],
          senderImage: '',
        ),
        channelId,
      );

      await _addToMyChat(ChatModel(
        time: Timestamp.now(),
        senderName: senderName,
        senderUID: senderId,
        senderPhoneNumber: senderPhoneNumber,
        recipientName: recipientName,
        recipientUID: recipientId,
        recipientPhoneNumber: recipientPhoneNumber,
        recentTextMessage: "Video",
        imageUrl: videoUrl,
        isRead: true,
        isArchived: false,
        channelId: channelId,
      ));
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<String> _uploadVideo(String channelId, File videoFile) async {
    final ref = storage.ref().child(
        'chat_videos/$channelId/${DateTime.now().millisecondsSinceEpoch}.mp4');
    final uploadTask = ref.putFile(videoFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
