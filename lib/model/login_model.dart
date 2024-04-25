class LoginModel {
  final String countryCode;
  final String countryName;
  late String phoneNum; 

  LoginModel({
    required this.countryCode,
    required this.countryName,
    String? phoneNum,
  }) : phoneNum = phoneNum ?? ''; 

  LoginModel copyWith({
    String? countryCode,
    String? countryName,
    String? phoneNum,
  }) {
    return LoginModel(
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }
}
