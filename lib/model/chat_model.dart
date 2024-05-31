import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String senderName;
  final String senderUID;
  final String recipientName;
  final String recipientUID;
  final String channelId;
  final String profileURL;
  final String recipientPhoneNumber;
  final String senderPhoneNumber;
  final String recentTextMessage;
  final bool isRead;
  final bool isArchived;
  final Timestamp time;

  ChatModel({
    required this.senderName,
    required this.senderUID,
    required this.recipientName,
    required this.recipientUID,
    required this.channelId,
    required this.profileURL,
    required this.recipientPhoneNumber,
    required this.senderPhoneNumber,
    required this.recentTextMessage,
    required this.isRead,
    required this.isArchived,
    required this.time,
  });

  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>; // Cast snapshot data to Map
    return ChatModel(
      senderName: data['senderName'],
      senderUID: data['senderUID'],
      senderPhoneNumber: data['senderPhoneNumber'],
      recipientName: data['recipientName'],
      recipientUID: data['recipientUID'],
      recipientPhoneNumber: data['recipientPhoneNumber'],
      channelId: data['channelId'],
      time: data['time'],
      isArchived: data['isArchived'],
      isRead: data['isRead'],
      recentTextMessage: data['recentTextMessage'],
      profileURL: data['profileURL'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "senderName": senderName,
      "senderUID": senderUID,
      "recipientName": recipientName,
      "recipientUID": recipientUID,
      "channelId": channelId,
      "profileURL": profileURL,
      "recipientPhoneNumber": recipientPhoneNumber,
      "senderPhoneNumber": senderPhoneNumber,
      "recentTextMessage": recentTextMessage,
      "isRead": isRead,
      "isArchived": isArchived,
      "time": time,
    };
  }

  @override
  List<Object> get props => [
        senderName,
        senderUID,
        recipientName,
        recipientUID,
        channelId,
        profileURL,
        recipientPhoneNumber,
        senderPhoneNumber,
        recentTextMessage,
        isRead,
        isArchived,
        time,
      ];
}
