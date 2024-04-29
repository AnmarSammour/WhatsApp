import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'package:whatsapp/model/login_model.dart';
part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId; // Holds the verification code

  PhoneAuthCubit() : super(PhoneAuthInitial());

  // Selecting the chosen country
  void selectCountry(LoginModel country) {
    emit(CountrySelectedState(country));
  }

  // Sending the phone number to Firebase
  Future<void> submitPhoneNumber(String countryCode, String phoneNumber) async {
    emit(Loading());

    String completePhoneNumber =
        '+$countryCode$phoneNumber'; // Constructing the complete number
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: completePhoneNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // If verification is successful
  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted');
    await signIn(credential);
  }

  // If verification fails
  void verificationFailed(FirebaseAuthException error) {
    print('verificationFailed : ${error.toString()}');
    emit(ErrorOccurred(errorMsg: error.toString()));
  }

  // When the verification code is sent
  void codeSent(String verificationId, int? resendToken) {
    print('codeSent: $verificationId');

    this.verificationId = verificationId;
    emit(PhoneNumberSubmited());
  }

  // When the verification code expires
  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout');
  }

  // Sending the entered verification code
  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otpCode);

    await signIn(credential);
  }

  // Signing in using the verification code
  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerified()); // Verification code verified
    } catch (error) {
      emit(ErrorOccurred(errorMsg: error.toString())); // An error occurred
    }
  }
}
