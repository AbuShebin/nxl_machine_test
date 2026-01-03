import 'package:fpdart/fpdart.dart';
import 'package:nxl_machine_test/core/errors/failures.dart';
import 'package:nxl_machine_test/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserModel?>> getCurrentUser();
}
