part of 'user_cubit.dart';

@immutable
sealed class UserState {}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}
