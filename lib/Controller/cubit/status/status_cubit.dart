import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp/model/status.dart';
import 'package:whatsapp/model/user.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  StatusCubit() : super(StatusInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> fetchStatuses() async {
    if (state is StatusInitial) {
      try {
        emit(StatusLoading());
        QuerySnapshot snapshot = await _firestore
            .collection('statuses')
            .orderBy('timestamp', descending: true)
            .get();
        List<Status> statuses =
            snapshot.docs.map((doc) => Status.fromSnapshot(doc)).toList();
        emit(StatusLoaded(statuses));
      } catch (e) {
        print('Error fetching statuses: $e');
        emit(StatusError("Failed to fetch statuses"));
      }
    }
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      return UserModel.fromSnapshot(snapshot);
    } catch (e) {
      throw Exception("Failed to fetch user");
    }
  }

  Future<void> addStatus(Status status, List<String> imagePaths) async {
    try {
      List<String> imageUrls = [];
      if (!status.isText) {
        for (String imagePath in imagePaths) {
          String imageUrl = await _uploadImage(imagePath);
          imageUrls.add(imageUrl);
        }
      }

      DocumentReference docRef = await _firestore.collection('statuses').add({
        'uid': status.userId,
        'imageUrls': imageUrls,
        'timestamp': status.timestamp,
        'isText': status.isText,
        'text': status.text,
        'backgroundColor': status.backgroundColor?.value,
      });

      await _firestore.collection('scheduled_deletions').add({
        'docId': docRef.id,
        'deleteAt': status.timestamp.add(Duration(hours: 24)),
      });

      await fetchStatuses();
    } catch (e) {
      print('Error adding status: $e');
      emit(StatusError("Failed to add status"));
    }
  }

  Future<String> _uploadImage(String imagePath) async {
    try {
      Reference ref =
          _storage.ref().child('statuses').child(imagePath.split('/').last);
      UploadTask uploadTask = ref.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image");
    }
  }
}
