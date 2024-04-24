part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class CountrySelectedState extends LoginState {
  final LoginModel selectedCountry;

  CountrySelectedState(this.selectedCountry);
}
