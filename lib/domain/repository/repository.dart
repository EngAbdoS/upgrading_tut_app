import 'package:firebase_auth/firebase_auth.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import 'package:dartz/dartz.dart';

import '../models/models.dart';

abstract class Repository {
  Future<Either<Failure, UserCredential>> login(LoginRequest loginRequest);

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, UserCredential>> register(
      RegisterRequest registerRequest);

  Future<Either<Failure, HomeObject>> getHomeData();
  Future<Either<Failure, StoreDetails>> getStoreDetails();

}
