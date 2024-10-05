import 'package:cloud_firestore/cloud_firestore.dart';

class Viewer {
  final String viewerId;
  final String viewerName;
  final String viewerImage;
  final DateTime viewedAt;

  Viewer({
    required this.viewerId,
    required this.viewerName,
    required this.viewerImage,
    required this.viewedAt,
  });

  factory Viewer.fromMap(Map<String, dynamic> data) {
    return Viewer(
      viewerId: data['uid'],
      viewerName: data['name'],
      viewerImage: data['imageUrl'],
      viewedAt: (data['viewedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': viewerId,
      'name': viewerName,
      'imageUrl': viewerImage,
      'viewedAt': Timestamp.fromDate(viewedAt),
    };
  }
}
