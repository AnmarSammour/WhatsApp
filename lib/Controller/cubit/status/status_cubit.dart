import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  StatusCubit() : super(StatusInitial());
}
