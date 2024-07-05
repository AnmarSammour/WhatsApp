
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime timestamp;
  final bool isText;
  final String text;

  Status({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.timestamp,
    required this.isText,
    required this.text,
  });

  factory Status.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return Status(
      id: snapshot.id,
      userId: data?['uid'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      timestamp: (data?['timestamp'] as Timestamp).toDate(),
      isText: data?['isText'] ?? false,
      text: data?['text'] ?? '',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': userId,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'isText': isText,
      'text': text,
    };
  }

  @override
  List<Object?> get props => [id, userId, imageUrl, timestamp, isText, text];
}
