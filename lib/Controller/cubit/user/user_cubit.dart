import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/controller/cubit/user/user_state.dart';
import 'package:whatsapp/model/user.dart';

class UserCubit extends Cubit<UserState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserCubit() : super(UserInitial()) {
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          UserModel userModel = UserModel(
            name: userDoc['name'],
            imageUrl: userDoc['imageUrl'],
            id: user.uid,
            phoneNumber: user.phoneNumber!,
            active: true,
            lastSeen: DateTime.now(),
            status: userDoc['status'],
          );
          emit(UserLoaded([userModel]));
        } else {
          emit(const UserError('User document does not exist'));
        }
      } else {
        emit(const UserError('No user logged in'));
      }
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }

  Future<void> updateUser(UserModel newUser, File? imageFile) async {
    try {
      String imageUrl = newUser.imageUrl;
      if (imageFile != null) {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child('user_images/${newUser.id}')
            .putFile(imageFile);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      await firestore.collection('users').doc(newUser.id).set({
        'uid': newUser.id,
        'name': newUser.name,
        'imageUrl': imageUrl,
        'phone': newUser.phoneNumber,
        'active': newUser.active,
        'lastSeen': newUser.lastSeen,
        'status': newUser.status,
      });

      emit(UserLoaded([newUser]));
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
}
