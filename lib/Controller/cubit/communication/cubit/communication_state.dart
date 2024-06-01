part of 'communication_cubit.dart';

sealed class CommunicationState extends Equatable {
  const CommunicationState();

  @override
  List<Object> get props => [];
}

final class CommunicationInitial extends CommunicationState {}
