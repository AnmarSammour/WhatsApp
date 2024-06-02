import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_numbers_state.dart';

class GetNumbersCubit extends Cubit<GetNumbersState> {
  GetNumbersCubit() : super(GetNumbersInitial());
}
