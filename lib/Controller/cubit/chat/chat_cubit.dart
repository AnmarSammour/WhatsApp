import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/Controller/cubit/chat/chat_state.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:whatsapp/model/group_chat.dart';

class ChatCubit extends Cubit<ChatState> {
  final FirebaseFirestore firestore;

  ChatCubit({required this.firestore}) : super(ChatInitial());

  Future<void> getChat({required String uid}) async {
    emit(ChatLoading());

    try {
      List<ChatModel> individualChats = await _fetchIndividualChats(uid);
      List<GroupChatModel> groupChats = await _fetchGroupChats(uid);

      individualChats.sort((a, b) => b.time.compareTo(a.time));

      groupChats.sort((a, b) => b.timeSent.compareTo(a.timeSent));

      emit(ChatLoaded(chatModel: individualChats, groupChats: groupChats));
    } catch (e) {
      emit(ChatFailure());
    }
  }

  Future<List<ChatModel>> _fetchIndividualChats(String uid) async {
    QuerySnapshot snapshot = await firestore
        .collection('myChats')
        .doc(uid)
        .collection('chats')
        .get();

    return snapshot.docs.map((doc) => ChatModel.fromSnapshot(doc)).toList();
  }

  Future<List<GroupChatModel>> _fetchGroupChats(String uid) async {
    QuerySnapshot snapshot = await firestore
        .collection('myChats')
        .doc(uid)
        .collection('groups')
        .get();

    return snapshot.docs
        .map((doc) => GroupChatModel.fromSnapshot(doc))
        .toList();
  }
}
