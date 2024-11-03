import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final bool active;
  final DateTime lastSeen;
  final String phoneNumber;
  final String status;

  const UserModel({
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
      id: data?['uid'] ?? '',
      name: data?['name'] ?? '',
      phoneNumber: data?['phone'] ?? '',
      active: data?['active'] ?? false,
      imageUrl: data?['imageUrl'] ?? '',
      status: data?['status'] ?? "Hey there! I am Using WhatsApp Clone.",
      lastSeen: (data?['lastSeen'] as Timestamp).toDate(),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['uid'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      active: map['active'],
      lastSeen: map['lastSeen'].toDate(),
      phoneNumber: map['phone'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "uid": id,
      "name": name,
      "phone": phoneNumber,
      "active": active,
      "imageUrl": imageUrl,
      "status": status,
      "lastSeen": Timestamp.fromDate(lastSeen),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        active,
        lastSeen,
        phoneNumber,
        status,
      ];
}
