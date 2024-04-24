import 'package:bloc/bloc.dart';

import '../../data/login_model.dart';

part 'login_cubit_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  void selectCountry(LoginModel country) {
    emit(CountrySelectedState(country));
  }
}
