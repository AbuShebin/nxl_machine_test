import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nxl_machine_test/features/auth/domain/entities/user_entity.dart';
import 'package:nxl_machine_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:nxl_machine_test/features/auth/presentation/providers/auth_repository_provider.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final UserEntity? user;

  AuthState({this.isLoading = false, this.error, this.user});

  bool get isAuthenticated => user != null;

  AuthState copyWith({bool? isLoading, String? error, UserEntity? user}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => state = AuthState(error: failure.message),
      (user) => state = AuthState(user: user),
    );
  }

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => state = AuthState(error: failure.message),
      (user) => state = AuthState(user: user),
    );
  }

  Future<void> register(String name, String email, String password) async {
    state = AuthState(isLoading: true);

    final result = await _authRepository.register(
      email: email,
      password: password,
      name: name,
    );

    result.fold(
      (failure) => state = AuthState(error: failure.message),
      (user) => state = AuthState(user: user),
    );
  }

  Future<void> logout() async {
    final result = await _authRepository.logout();
    result.fold(
      (failure) => state = AuthState(error: failure.message, user: state.user),
      (_) => state = AuthState(),
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
