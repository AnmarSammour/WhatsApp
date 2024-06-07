import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp/enum/message_enum.dart';

class MessageModel extends Equatable {
  final String senderName;
  final String senderUID;
  final String recipientName;
  final String recipientUID;
  final MessageType messageType;
  final String message;
  final String messageId;
  final Timestamp time;

  const MessageModel({
    required this.senderName,
    required this.senderUID,
    required this.recipientName,
    required this.recipientUID,
    required this.messageType,
    required this.message,
    required this.messageId,
    required this.time,
  });

  factory MessageModel.fromSnapShot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MessageModel(
      senderName: data['senderName'],
      senderUID: data['senderUID'],
      recipientName: data['recipientName'],
      recipientUID: data['recipientUID'],
      messageType: MessageType.values[data['messageType']],
      message: data['message'],
      messageId: data['messageId'],
      time: data['time'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "senderName": senderName,
      "senderUID": senderUID,
      "recipientName": recipientName,
      "recipientUID": recipientUID,
      "messageType": messageType.index,
      "message": message,
      "messageId": messageId,
      "time": time,
    };
  }

  @override
  List<Object> get props => [
        senderName,
        senderUID,
        recipientName,
        recipientUID,
        messageType,
        message,
        messageId,
        time,
      ];
}
