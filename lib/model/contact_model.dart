import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String phoneNumber;
  final String id;
  final String status;
  final String name;

  ContactModel({
    required this.phoneNumber,
    required this.id,
    required this.status,
    required this.name,
  });

  factory ContactModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContactModel(
      id: doc.id,
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'status': status,
    };
  }

  List<Object> get props => [id, name, phoneNumber];
}
