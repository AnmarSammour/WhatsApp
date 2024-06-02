import 'package:equatable/equatable.dart';
import 'package:whatsapp/model/contact_model.dart';

abstract class GetNumbersState extends Equatable {
  const GetNumbersState();

  @override
  List<Object> get props => [];
}

class GetNumbersInitial extends GetNumbersState {}

class GetNumbersLoading extends GetNumbersState {}

class GetNumbersLoaded extends GetNumbersState {
  final List<ContactModel> contacts;

  const GetNumbersLoaded({required this.contacts});

  @override
  List<Object> get props => [contacts];
}

class GetNumbersFailure extends GetNumbersState {
  final String error;

  const GetNumbersFailure(this.error);

  @override
  List<Object> get props => [error];
}
