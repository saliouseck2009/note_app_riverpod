import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/auth_repository.dart';
import 'package:note_app_riv/auth_state.dart';
import 'package:note_app_riv/utils/shared_preference.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  //final SharedPreferences prefs =  SharedPreferences.getInstance();
  AuthController({required this.authRepository,})
      : super(AuthInitial());

  void login(String username, String password) async {
    state = AuthLoading();
    try {
      final result = await authRepository.login(username, password);
      state = AuthSuccess(token: result);
    } catch (e) {
      state = AuthFailure(message: e.toString());
    }
  }

  void signup(String username, String password, String email) async {
    state = AuthLoading();
    try {
      final result = await authRepository.signup(
          username: username, password: password, email: email);
      state = AuthSuccess(token: result);
    } catch (e) {
      state = AuthFailure(message: e.toString());
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final prefs = await ref.read(prefsProvider);
  return AuthController(authRepository: authRepository, prefs: prefs);
});
