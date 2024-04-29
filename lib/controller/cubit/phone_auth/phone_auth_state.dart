part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class Loading extends PhoneAuthState {}

class ErrorOccurred extends PhoneAuthState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

// When the user submits the phone number
class PhoneNumberSubmited extends PhoneAuthState {}

// When the user verifies the OTP
class PhoneOTPVerified extends PhoneAuthState {}

class CountrySelectedState extends PhoneAuthState {
  final LoginModel selectedCountry;

  CountrySelectedState(this.selectedCountry);
}

