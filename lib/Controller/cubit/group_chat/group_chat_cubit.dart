import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/model/group_chat.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/enum/message_enum.dart';
import 'package:whatsapp/model/user.dart';

part 'group_chat_state.dart';

class GroupChatCubit extends Cubit<GroupChatState> {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  GroupChatCubit({
    required this.firestore,
    required this.storage,
    required this.auth,
  }) : super(GroupChatInitial());

  Future<String> getSenderName(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get();
      return userDoc.data()?['name'] ?? 'Unknown';
    } catch (e) {
      throw Exception('Failed to fetch sender name');
    }
  }

  Future<String> getSenderImage(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get();
      return userDoc.data()?['imageUrl'] ?? '';
    } catch (e) {
      throw Exception('Failed to fetch sender image');
    }
  }

  Future<void> sendGroupTextMessage({
    required String groupId,
    required String message,
    required List<String> membersUid,
  }) async {
    try {
      final senderId = auth.currentUser!.uid;
      final senderName = await getSenderName(senderId);
      final senderImage = await getSenderImage(senderId);

      await _sendGroupMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          senderImage: senderImage,
          messageType: MessageType.text,
          message: message,
          time: Timestamp.now(),
          recipientUID: '',
          recipientName: '',
          membersUid: membersUid,
        ),
        groupId,
      );
      await _updateGroupChat(
        groupId: groupId,
        lastMessage: message,
        senderName: senderName,
        senderId: senderId,
        senderImage: senderImage,
      );
    } catch (e) {
      emit(GroupChatFailure());
    }
  }

  Future<void> sendGroupImageMessage({
    required String groupId,
    required File imageFile,
    required String caption,
    required List<String> membersUid,
  }) async {
    try {
      final senderId = auth.currentUser!.uid;
      final senderName = await getSenderName(senderId);
      final imageUrl = await _uploadImage(groupId, imageFile);
      final senderImage = await getSenderImage(senderId);

      final message = imageUrl + (caption.isNotEmpty ? '\n$caption' : '');

      await _sendGroupMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          senderImage: senderImage,
          messageType: MessageType.image,
          message: message,
          time: Timestamp.now(),
          recipientUID: '',
          recipientName: '',
          membersUid: membersUid,
        ),
        groupId,
      );
      await _updateGroupChat(
        groupId: groupId,
        lastMessage: "Image",
        senderName: senderName,
        senderId: senderId,
        senderImage: senderImage,
      );
    } on SocketException catch (_) {
      emit(GroupChatFailure());
    } catch (_) {
      emit(GroupChatFailure());
    }
  }

  Future<void> sendGroupAudioMessage({
    required String groupId,
    required File audioFile,
    required List<String> membersUid,
  }) async {
    try {
      final senderId = auth.currentUser!.uid;
      final senderName = await getSenderName(senderId);
      final senderImage = await getSenderImage(senderId);

      final audioUrl = await _uploadAudio(groupId, audioFile);

      await _sendGroupMessage(
        MessageModel(
          senderName: senderName,
          senderUID: senderId,
          senderImage: senderImage,
          messageType: MessageType.audio,
          message: audioUrl,
          time: Timestamp.now(),
          recipientUID: '',
          recipientName: '',
          membersUid: membersUid,
        ),
        groupId,
      );
      await _updateGroupChat(
        groupId: groupId,
        lastMessage: "Audio",
        senderName: senderName,
        senderId: senderId,
        senderImage: senderImage,
      );
    } catch (e) {
      emit(GroupChatFailure());
    }
  }

  Future<String> createGroup({
    required String groupName,
    required File? profilePic,
    required List<String> membersUid,
    required String senderName,
  }) async {
    try {
      final senderId = auth.currentUser!.uid;
      final groupId = firestore.collection('groups').doc().id;
      String profileUrl = profilePic != null
          ? await uploadImageToFirebase(profilePic, groupId)
          : '';

      List<String> allMembersUid = List.from(membersUid)..add(senderId);

      final groupChat = GroupChatModel(
        groupCreatorId: senderId,
        groupCreator: senderName,
        senderId: '',
        senderName: '',
        name: groupName,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: allMembersUid,
        timeSent: DateTime.now(),
        senderImage: '',
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
    required String senderName,
    required String senderId,
    required String senderImage,
  }) async {
    try {
      await firestore.collection('groups').doc(groupId).update({
        'lastMessage': lastMessage,
        'timeSent': Timestamp.now(),
        'senderName': senderName,
        'senderUID': senderId,
        'senderImage': senderImage,
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
          'senderName': senderName,
          'senderUID': senderId,
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

  Future<List<UserModel>> getCurrentGroupMembers(String groupId) async {
    try {
      final groupSnapshot =
          await firestore.collection('groups').doc(groupId).get();
      final groupChat = GroupChatModel.fromSnapshot(groupSnapshot);
      final memberIds = groupChat.membersUid;

      final membersSnapshots = await firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: memberIds)
          .get();

      return membersSnapshots.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch group members');
    }
  }

  Future<void> addMembersToGroup({
    required String groupId,
    required List<String> newMemberIds,
  }) async {
    try {
      final currentUserId = auth.currentUser!.uid;
      final currentUserDoc =
          await firestore.collection('users').doc(currentUserId).get();
      final currentUserName = currentUserDoc.data()?['name'] ?? 'You';

      final newMembersDocs = await firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: newMemberIds)
          .get();

      List<String> newMemberNames = newMembersDocs.docs
          .map((doc) => doc.data()['name'] as String)
          .toList();

      final addedMembersString = newMemberNames.join(', ');
      final lastMessage = '$currentUserName added $addedMembersString';

      DocumentReference groupRef = firestore.collection('groups').doc(groupId);
      await groupRef.update({
        'membersUid': FieldValue.arrayUnion(newMemberIds),
      });

      final groupSnapshot = await groupRef.get();
      final groupChat = GroupChatModel.fromSnapshot(groupSnapshot);

      final allMemberIds = List.from(groupChat.membersUid)..add(currentUserId);

      for (String memberId in allMemberIds) {
        await firestore
            .collection('myChats')
            .doc(memberId)
            .collection('groups')
            .doc(groupId)
            .set({
          ...groupChat.toDocument(),
          'lastMessage': lastMessage,
          'timeSent': Timestamp.now(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error adding members to group: $e');
      emit(GroupChatFailure());
    }
  }

  Future<void> updateGroupName({
    required String groupId,
    required String newGroupName,
  }) async {
    if (newGroupName.isNotEmpty) {
      try {
        await firestore
            .collection('groups')
            .doc(groupId)
            .update({'name': newGroupName});

        final groupSnapshot =
            await firestore.collection('groups').doc(groupId).get();
        final groupChat = GroupChatModel.fromSnapshot(groupSnapshot);

        for (String memberUid in groupChat.membersUid) {
          await firestore
              .collection('myChats')
              .doc(memberUid)
              .collection('groups')
              .doc(groupId)
              .update({'name': newGroupName});
        }
      } catch (e) {
        print('Error updating group name: $e');
      }
    }
  }
}
