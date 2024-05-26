import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final bool active;
  final int lastSeen;
  final String phoneNumber;
  final String status;

  UserModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.active,
    required this.lastSeen,
    required this.phoneNumber,
    this.status = "Hey there! I am Using WhatsApp Clone.",
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return UserModel(
      id: data?['uid'] ?? '', // Assuming 'uid' is the unique identifier in Firestore
      name: data?['name'] ?? '',
      phoneNumber: data?['phoneNumber'] ?? '',
      active: data?['isOnline'] ?? false, // Mapping 'isOnline' to 'active'
      imageUrl: data?['profileUrl'] ?? '',
      status: data?['status'] ?? "Hey there! I am Using WhatsApp Clone.",
      lastSeen: data?['lastSeen'] ?? 0, // Assuming 'lastSeen' is an int
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "uid": id,
      "name": name,
      "phoneNumber": phoneNumber,
      "isOnline": active, // Mapping 'active' to 'isOnline'
      "profileUrl": imageUrl,
      "status": status,
      "lastSeen": lastSeen,
    };
  }

  @override
  List<Object> get props => [
        id,
        name,
        imageUrl,
        active,
        lastSeen,
        phoneNumber,
        status,
      ];
}
