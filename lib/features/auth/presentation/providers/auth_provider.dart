import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({this.isLoading = false, this.error, this.isAuthenticated = false});

  AuthState copyWith({bool? isLoading, String? error, bool? isAuthenticated}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error:
          error, // Nullable, so if not passed, it remains null if we want to clear it? No, usually we want to clear it explicitly or keep it. Here I'll assume passing null clears it if I assign it.
      // Wait, standard copyWith usually takes nullable to allow clearing? No, typical copyWith takes optional nullable.
      // Let's just make it simple: if passed, use it. If I want to clear, I'll pass null? That's tricky in Dart.
      // For error, I'll treating passing null as "keep existing" helps, but clearing is needed.
      // Let's change the pattern slightly or just handle it in logic.
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 2)); // Mock API delay

    if (email == 'test@test.com' && password == '123456') {
      state = AuthState(isLoading: false, isAuthenticated: true);
    } else {
      state = AuthState(
        isLoading: false,
        error: 'Invalid Credentials (Try test@test.com / 123456)',
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = AuthState(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 2)); // Mock API delay

    // Always succeed for mock registration
    state = AuthState(isLoading: false, isAuthenticated: true);
  }

  void logout() {
    state = AuthState();
  }

  void clearError() {
    // Create a new state but keep others, just clear error
    state = AuthState(
      isLoading: state.isLoading,
      isAuthenticated: state.isAuthenticated,
      error: null,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
