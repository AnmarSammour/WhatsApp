import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final String id;
  final String userId;
  final List<String> imageUrls;
  final DateTime timestamp;
  final bool isText;
  final String text;
  final Color? backgroundColor;

  const Status({
    required this.id,
    required this.userId,
    required this.imageUrls,
    required this.timestamp,
    required this.isText,
    required this.text,
    this.backgroundColor,
  });

  factory Status.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Snapshot data is null");
    }

    try {
      return Status(
        id: snapshot.id,
        userId: data['uid'] is String ? data['uid'] : data['uid'].toString(),
        imageUrls: List<String>.from(data['imageUrls'] ?? []),
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        isText: data['isText'] ?? false,
        text: data['text'] ?? '',
        backgroundColor: data['backgroundColor'] != null
            ? Color(int.parse(data['backgroundColor'].toString(), radix: 16))
            : null,
      );
    } catch (e) {
      print('Error parsing snapshot data: $data');
      rethrow;
    }
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': userId,
      'imageUrls': imageUrls,
      'timestamp': Timestamp.fromDate(timestamp),
      'isText': isText,
      'text': text,
      'backgroundColor': backgroundColor?.value.toRadixString(16),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        imageUrls,
        timestamp,
        isText,
        text,
        backgroundColor,
      ];
}
