import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatModel {
  final String groupCreatorId;
  final String groupCreator;
  final String senderId;
  final String senderName;
  final String senderImage;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final DateTime timeSent;
  final bool isGroupChat;

  GroupChatModel({
    required this.groupCreatorId,
    required this.groupCreator,
    required this.senderId,
    required this.senderName,
    required this.senderImage,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeSent,
    this.isGroupChat = true,
  });

  Map<String, dynamic> toDocument() {
    return {
      'groupCreatorId': groupCreatorId,
      'groupCreator': groupCreator,
      'senderUID': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'timeSent': Timestamp.fromDate(timeSent),
      'isGroupChat': isGroupChat,
    };
  }

  factory GroupChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>? ?? {};
    return GroupChatModel(
      groupCreatorId: data['groupCreatorId'] ?? '',
      groupCreator: data['groupCreator'] ?? '',
      senderId: data['senderUID'] ?? '',
      senderName: data['senderName'] ?? '',
      senderImage: data['senderImage'] ?? '',
      name: data['name'] ?? '',
      groupId: data['groupId'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      groupPic: data['groupPic'] ?? '',
      membersUid: List<String>.from(data['membersUid'] ?? []),
      timeSent: (data['timeSent'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isGroupChat: data['isGroupChat'] ?? true,
    );
  }
}
