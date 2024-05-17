import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/controller/cubit/user/user_state.dart';
import 'package:whatsapp/model/user.dart';

class UserCubit extends Cubit<UserState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserCubit() : super(UserInitial());

  Future<void> updateUser(UserModel newUser, File? imageFile) async {
    emit(UserLoading());

    try {
      // Upload image to Firebase Storage
      String imageUrl = '';
      if (imageFile != null) {
        TaskSnapshot snapshot = await _storage
            .ref()
            .child('user_images/${newUser.name}')
            .putFile(imageFile);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // Update user data in Firestore
      User? user = FirebaseAuth.instance.currentUser;
      await _firestore.collection('users').doc(user!.uid).set({
        'name': newUser.name,
        'imageUrl': imageUrl,
        'phone': user.phoneNumber,
      });

      emit(UserLoaded(newUser));
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
}

