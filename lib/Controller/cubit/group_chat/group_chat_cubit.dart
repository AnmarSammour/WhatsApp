import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/model/message_model.dart';
import 'package:whatsapp/model/user.dart';

part 'group_chat_state.dart';

class GroupChatCubit extends Cubit<GroupChatState> {
  final FirebaseFirestore firestore;

  GroupChatCubit({
    required this.firestore,
  }) : super(GroupChatInitial());

  Future<void> getAllUsers() async {
    try {
      emit(GroupChatLoading());
      QuerySnapshot snapshot = await firestore.collection('users').get();

      List<UserModel> loadedUsers = [];
      snapshot.docs.forEach((doc) {
        if (doc.exists) {
          loadedUsers.add(UserModel.fromSnapshot(doc));
        }
      });

      emit(GroupChatUsersLoaded(users: loadedUsers));
    } catch (error) {
      emit(GroupChatError(errorMessage: 'Error fetching users: $error'));
    }
  }
}
