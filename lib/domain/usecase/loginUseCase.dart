import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flu_proj/data/network/failure.dart';
import 'package:flu_proj/data/network/requests.dart';
import 'package:flu_proj/domain/models/models.dart';
import 'package:flu_proj/domain/repository/repository.dart';
import 'package:flu_proj/domain/usecase/base_use_case.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, UserCredential> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserCredential>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}


class LoginUseCaseInput {
  String email;
  String password;

  LoginUseCaseInput(this.email, this.password);
}

