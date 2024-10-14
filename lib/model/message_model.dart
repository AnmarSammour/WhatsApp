import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/enum/message_enum.dart';

class MessageModel extends Equatable {
  final String senderName;
  final String senderUID;
  final String recipientName;
  final String recipientUID;
  final String senderImage;
  final MessageType messageType;
  final String message;
  final Timestamp time;
  final List<String> membersUid;

  const MessageModel({
    required this.senderName,
    required this.senderUID,
    required this.senderImage,
    required this.recipientName,
    required this.recipientUID,
    required this.messageType,
    required this.message,
    required this.time,
    required this.membersUid,
  });

  factory MessageModel.fromSnapShot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return MessageModel(
      senderName: data['senderName'] ?? '',
      senderUID: data['senderUID'] ?? '',
      senderImage: data['senderImage'] ?? '',
      recipientName: data['recipientName'] ?? '',
      recipientUID: data['recipientUID'] ?? '',
      message: data['message'] ?? '',
      messageType: MessageType.values[data['messageType'] ?? 0],
      time: data['time'] as Timestamp? ?? Timestamp.now(),
      membersUid: List<String>.from(data['membersUid'] ?? []),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'senderName': senderName,
      'senderUID': senderUID,
      'senderImage': senderImage,
      'recipientName': recipientName,
      'recipientUID': recipientUID,
      'message': message,
      'messageType': messageType.index,
      'time': time,
      'membersUid': membersUid,
    };
  }

  @override
  List<Object> get props => [
        senderName,
        senderUID,
        senderImage,
        recipientName,
        recipientUID,
        messageType,
        message,
        time,
        membersUid,
      ];
}
