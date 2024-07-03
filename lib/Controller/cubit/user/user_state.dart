import 'package:whatsapp/model/user.dart';

abstract class UserState {
  const UserState();

  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}
