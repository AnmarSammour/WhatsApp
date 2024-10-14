part of 'status_cubit.dart';

sealed class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object> get props => [];
}

final class StatusInitial extends StatusState {}

final class StatusLoading extends StatusState {}

final class StatusLoaded extends StatusState {
  final List<Status> statuses;

  const StatusLoaded(this.statuses);

  @override
  List<Object> get props => [statuses];
}

final class StatusError extends StatusState {
  final String message;

  const StatusError(this.message);

  @override
  List<Object> get props => [message];
}
