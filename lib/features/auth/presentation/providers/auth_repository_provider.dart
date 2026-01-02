import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nxl_machine_test/core/providers/firebase_providers.dart';
import 'package:nxl_machine_test/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nxl_machine_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nxl_machine_test/features/auth/domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});
