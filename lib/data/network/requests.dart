class LoginRequest {
  String email;
  String password;

  LoginRequest(this.email, this.password);
}

class RegisterRequest {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;
  String? uId;
  bool isVerefide;

  RegisterRequest(
      {required this.userName,
      required this.countryMobileCode,
      required this.mobileNumber,
      required this.email,
      required this.password,
      required this.profilePicture,
      this.uId,
      this.isVerefide = false});
}

extension RegisterRequestExtention on RegisterRequest {
  Map<String, dynamic> tpMap() {
    return {
      'name': userName,
      'countryMobileCode': countryMobileCode,
      'mobileNumber': mobileNumber,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
      'uId': uId,
      'isVerefide': isVerefide,
    };
  }
}
