import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/enum/message_enum.dart';
import 'package:whatsapp/model/user.dart';

part 'group_chat_state.dart';

class GroupChatCubit extends Cubit<GroupChatState> {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  GroupChatCubit({required this.firestore, required this.storage})
      : super(GroupChatInitial());

  Future<void> sendGroupTextMessage({
    required String senderName,
    required String senderId,
    required String groupId,
    required String message,
  }) async {
    try {
      await _sendGroupMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          messageType: MessageType.text,
          message: message,
          time: Timestamp.now(),
          recipientUID: '',
          recipientName: '',
        ),
        groupId,
      );
      await _updateGroupChat(
        groupId: groupId,
        lastMessage: message,
      );
    } on SocketException catch (_) {
      emit(GroupChatFailure());
    } catch (_) {
      emit(GroupChatFailure());
    }
  }

  Future<void> sendGroupImageMessage({
    required String senderName,
    required String senderId,
    required String groupId,
    required File imageFile,
    required String caption,
  }) async {
    try {
      final imageUrl = await _uploadImage(groupId, imageFile);
      final message = imageUrl + (caption.isNotEmpty ? '\n$caption' : '');
      await _sendGroupMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          messageType: MessageType.image,
          message: message,
          time: Timestamp.now(),
          recipientUID: '',
          recipientName: '',
        ),
        groupId,
      );
      await _updateGroupChat(
        groupId: groupId,
        lastMessage: "Image",
      );
    } on SocketException catch (_) {
      emit(GroupChatFailure());
    } catch (_) {
      emit(GroupChatFailure());
    }
  }

  Future<String> createGroup({
    required String groupName,
    required File? profilePic,
    required List<String> membersUid,
    required String senderId,
    required String senderName,
  }) async {
    try {
      final groupId = firestore.collection('groups').doc().id;
      String profileUrl = profilePic != null
          ? await uploadImageToFirebase(profilePic, groupId)
          : '';

      List<String> allMembersUid = List.from(membersUid)..add(senderId);

      final groupChat = GroupChatModel(
        senderId: senderId,
        senderName: senderName,
        name: groupName,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: allMembersUid,
        timeSent: DateTime.now(),
      );

      await firestore
          .collection('groups')
          .doc(groupId)
          .set(groupChat.toDocument());

      for (String memberUid in allMembersUid) {
        String lastMessage;
        if (memberUid == senderId) {
          lastMessage = 'You created this group';
        } else {
          lastMessage = '$senderName added you';
        }

        await firestore
            .collection('myChats')
            .doc(memberUid)
            .collection('groups')
            .doc(groupId)
            .set({
          ...groupChat.toDocument(),
          'lastMessage': lastMessage,
        });
      }

      return groupId;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getGroupMessages({required String groupId}) async {
    emit(GroupChatLoading());
    try {
      final messagesStream = _getGroupMessages(groupId);
      messagesStream.listen((messages) {
        emit(GroupChatLoaded(messages: messages));
      });
    } on SocketException catch (_) {
      emit(GroupChatFailure());
    } catch (_) {
      emit(GroupChatFailure());
    }
  }

  Future<void> sendGroupAudioMessage({
    required String senderName,
    required String senderId,
    required String groupId,
    required File audioFile,
  }) async {
    try {
      final audioUrl = await _uploadAudio(groupId, audioFile);
      await _sendGroupMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          messageType: MessageType.audio,
          message: audioUrl,
          time: Timestamp.now(),
          recipientUID: '',
          recipientName: '',
        ),
        groupId,
      );
      await _updateGroupChat(
        groupId: groupId,
        lastMessage: "Audio",
      );
    } catch (e) {
      emit(GroupChatFailure());
    }
  }

  Future<void> _sendGroupMessage(MessageModel message, String groupId) async {
    try {
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .add(message.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MessageModel>> _getGroupMessages(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => MessageModel.fromSnapShot(doc))
            .toList());
  }

  Future<void> _updateGroupChat({
    required String groupId,
    required String lastMessage,
  }) async {
    try {
      await firestore.collection('groups').doc(groupId).update({
        'lastMessage': lastMessage,
        'timeSent': Timestamp.now(),
      });

      final groupSnapshot =
          await firestore.collection('groups').doc(groupId).get();
      final groupChat = GroupChatModel.fromSnapshot(groupSnapshot);

      for (String memberUid in groupChat.membersUid) {
        await firestore
            .collection('myChats')
            .doc(memberUid)
            .collection('groups')
            .doc(groupId)
            .update({
          'lastMessage': lastMessage,
          'timeSent': Timestamp.now(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _uploadImage(String groupId, File imageFile) async {
    final ref = storage.ref().child(
        'group_images/$groupId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> _uploadAudio(String groupId, File audioFile) async {
    final ref = storage.ref().child(
        'audio_messages/$groupId/${DateTime.now().millisecondsSinceEpoch}.m4a');
    final uploadTask = ref.putFile(audioFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadImageToFirebase(File image, String groupId) async {
    final ref = storage.ref().child(
        'group_images/$groupId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> getAllUsers() async {
    try {
      emit(GroupChatLoading());
      QuerySnapshot snapshot = await firestore.collection('users').get();

      List<UserModel> loadedUsers =
          snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();

      emit(GroupChatUsersLoaded(users: loadedUsers));
    } catch (e) {
      emit(GroupChatError(errorMessage: e.toString()));
    }
  }
}
