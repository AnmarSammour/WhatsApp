import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/model/viewer.dart';

class Status extends Equatable {
  final String statusId;
  final String userId;
  final List<String> imageUrls;
  final DateTime timestamp;
  final bool isText;
  final String text;
  final Color? backgroundColor;
  final List<Viewer> viewers;

  const Status({
    required this.statusId,
    required this.userId,
    required this.imageUrls,
    required this.timestamp,
    required this.isText,
    required this.text,
    this.backgroundColor,
    this.viewers = const [],
  });

  factory Status.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Snapshot data is null");
    }
    return Status(
      statusId: snapshot.id,
      userId: data['uid'] is String ? data['uid'] : data['uid'].toString(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isText: data['isText'] ?? false,
      text: data['text'] ?? '',
      backgroundColor: data['backgroundColor'] != null
          ? Color(data['backgroundColor'])
          : null,
      viewers: (data['viewers'] as List<dynamic>?)
              ?.map((e) => Viewer.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': userId,
      'imageUrls': imageUrls,
      'timestamp': Timestamp.fromDate(timestamp),
      'isText': isText,
      'text': text,
      'backgroundColor': backgroundColor?.value,
      'viewers': viewers
          .map((v) => v.toMap())
          .toList(), 
    };
  }

  @override
  List<Object?> get props => [
        statusId,
        userId,
        imageUrls,
        timestamp,
        isText,
        text,
        backgroundColor,
        viewers,
      ];
}
