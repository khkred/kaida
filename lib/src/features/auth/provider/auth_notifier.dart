import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaida/src/features/auth/provider/auth_state.dart';
import 'package:kaida/src/features/auth/repository/auth_repository.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  // So when the AuthNotifier is called for the first time. We set the Auth State as AuthStateInitial
  AuthNotifier(this._authRepository) : super(const AuthStateInitial());

  Future<void> signIn(String email, String password) async {
    state = const AuthStateAuthenticating();

    try {
      final userId = await _authRepository.signIn(email, password);

      //TODO: HANDLE CASE WHEN userId = null
      state = AuthStateAuthenticated(userId);
    } catch (e) {
      state = const AuthStateUnAuthenticated();
    }
  }

  Future<void> signUp(
      String email, String password, String name, String phoneNumber) async {
    state = const AuthStateAuthenticating();

    try {
      final userId =
          await _authRepository.signUp(email, password, name, phoneNumber);

      state = AuthStateAuthenticated(userId);
    } catch (e) {
      state = const AuthStateUnAuthenticated();
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AuthStateUnAuthenticated();
  }
}
