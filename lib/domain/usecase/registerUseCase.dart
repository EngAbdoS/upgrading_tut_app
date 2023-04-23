import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flu_proj/data/network/failure.dart';
import 'package:flu_proj/data/network/requests.dart';
import 'package:flu_proj/domain/models/models.dart';
import 'package:flu_proj/domain/repository/repository.dart';
import 'package:flu_proj/domain/usecase/base_use_case.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, UserCredential> {
  final Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, UserCredential>> execute(
      RegisterUseCaseInput input) async {
    return await _repository.register(RegisterRequest(
        userName: input.userName,
        countryMobileCode: input.countryMobileCode,
        mobileNumber: input.mobileNumber,
        email: input.email,
        password: input.password,
        profilePicture: input.profilePicture));
  }
}

class RegisterUseCaseInput {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;

  RegisterUseCaseInput(this.userName, this.countryMobileCode, this.mobileNumber,
      this.email, this.password, this.profilePicture);
}
