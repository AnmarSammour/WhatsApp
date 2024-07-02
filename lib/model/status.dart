import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime timestamp;

  Status({required this.id, required this.userId, required this.imageUrl, required this.timestamp});

  factory Status.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return Status(
      id: snapshot.id,
      userId: data?['userId'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      timestamp: (data?['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
