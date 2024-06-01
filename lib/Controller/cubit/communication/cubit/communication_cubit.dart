import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  CommunicationCubit() : super(CommunicationInitial());
}
