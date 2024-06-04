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

      state = AuthStateAuthenticated(userId);
    } catch (e) {
      print('SignIn Error $e');
      state = const AuthStateUnAuthenticated();
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthStateAuthenticating();
    try {
      final userId = await _authRepository.signInWithGoogle();
      state = AuthStateAuthenticated(userId);
    } catch (e) {
      print('Google SignIn Error: $e');
      rethrow;
    }
  }

  Future<void> signUp(
      String email, String password, String name, String phoneNumber) async {
    state = const AuthStateAuthenticating();

    try {
      final userId =
          await _authRepository.signUp(email, password, name, phoneNumber);

      print("User Id: $userId");

      state = AuthStateAuthenticated(userId);
    } catch (e) {
      print("SignUp Error : $e");
      state = const AuthStateUnAuthenticated();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      print('ResetPassword Error: $e');
      throw e;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _authRepository.changePassword(oldPassword, newPassword);
    } catch (e) {
      print('ChangePassword Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AuthStateUnAuthenticated();
    } catch (e) {
      print('SignOut Error: $e');
      rethrow;
    }
  }
}
