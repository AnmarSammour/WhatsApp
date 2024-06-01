import 'package:equatable/equatable.dart';
import 'package:whatsapp/model/message_model.dart';

class CommunicationState extends Equatable {
  const CommunicationState();

  @override
  List<Object> get props => [];
}

class CommunicationInitial extends CommunicationState {}

class CommunicationLoaded extends CommunicationState {
  final List<MessageModel> messages;

  CommunicationLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class CommunicationFailure extends CommunicationState {}

class CommunicationLoading extends CommunicationState {}
